class Bitbot

  # Base responders

  @BaseResponder: require('./bitbot/responders/base_responder')
  @RegexpResponder: require('./bitbot/responders/regexp_responder')

  # Core extensions

  @log: require('./bitbot/logger')
  @load: require('./bitbot/loader')

  # Class variables / methods

  @logPrefix: 'Core:'
  @bots: {}

  @loadConfig: (@configPath) ->
    @load @configPath, name: 'configuration', (err, content) =>
      @log(err.message, 'error') && process.exit() if (err)

      for name, config of JSON.parse(content)
        @verifyConfig config, (config, token, account) =>
          @create(name, config, token, account)


  @verifyConfig: (config, callback) ->
    account = process.env.CAMPFIRE_ACCOUNT
    token = config.token
    env = token.replace(/^>/, '')

    if !token
      return @log("No token specified for #{name}", 'error')

    if token.match(/^>/) && !token = process.env[env]
      return @log("Missing environment token for #{env}", 'error')

    callback(config, token, account)


  @create: (name, config, token, account) ->
    @log("Creating bot \033[33m#{name}")

    client = new Campfire(ssl: true, account: account, token: token)
    client.me (err, response) =>
      return @log("Unable to connect (#{err.message})", 'error') if err

      user = response.user
      @bots[user.id] = new Bitbot(name, client, user, config)

  # Instance methods

  log: @log
  load: @load

  constructor: (@name, @client, @user, @config) ->
    @logPrefix = "#{@name}:"
    @users = new UserRegistry("#{@name}-users", @client)

    # todo: move this off into a nicer place
    @respondsTo = @config.respondsTo || []
    @respondsTo = [@respondsTo] unless _(@respondsTo).isArray()
    @respondsTo.push(@user.name)
    @config.allowedReferences ||= ['hey', 'yeah', 'yes', 'excuse me', 'please', 'yo', 'word']
    allowed = @config.allowedReferences.join('|')
    respond = @respondsTo.join('|')
    regex = "^((#{allowed})[;:,.]?\\s+)?(#{respond})[;:,.]?\\s+|\\s+(#{respond})[?!.~]*$"
    @respondsToRegexp = new RegExp(regex, 'gi')

    @log("Connected (\033[33m#{user.id}\033[37m)")
    @log("Responding to \033[35m#{@respondsTo.join(', ')}")

    @initialize()


  initialize: ->
    @joinRooms()
    @loadResponders()


  reload: ->
    @load Bitbot.configPath, name: 'configuration', (err, content) =>
      return @log("Unable to load configuration: #{err}", 'error') if (err)

      for name, config of JSON.parse(content)
        continue unless name == @name
        Bitbot.verifyConfig config, (config) =>
          @config = config
          @initialize()


  joinRooms: ->
    @rooms ||= {}

    @client.rooms (err, rooms) =>
      return @log("Unable to get room list #{err}", 'error') if err

      @joinOrLeaveRoom(room) for room in rooms


  joinOrLeaveRoom: (room, allowed) =>
    if @isAllowedRoom(room.name, @config.rooms)
      return if @rooms[room.id]
      @log("Joining \033[32m#{room.name}")

      (@rooms[room.id] = room).join =>
        room.confirms = {}
        room.prompts = {}
        room.listen (message) => @receivedMessage(room, message)

    else if @rooms[room.id]
      @log("Leaving \033[32m#{room.name}")

      room.leave()
      delete(@rooms[room.id])


  loadResponders: ->
    for name, responder of @responder
      for interval in responder.intervals || []
        clearInterval(interval)

    @responders = {}

    for name, responder of @config.responders
      # todo: should load from more than one path -- checking in a few places
      source = responder.url || Path.join(root, 'lib', 'responders', responder.file || responder)

      opts = name: "#{name} responder",
      @load source, _(opts).extend(responder), (err, handler) =>
        return @log("#{name} - #{err.message}", 'error') if err

        handler.bot = @ if responder.core

        @responders[name] = handler: handler, rooms: responder.rooms || true
        @addResponderIntervals(name) if handler.intervals


  addResponderIntervals: (name) ->
    respond = (response) =>
      return unless _(response).isObject()
      ids = response.rooms || Object.keys(@rooms)
      for id in ids
        room = @rooms[id]
        continue unless room && @isAllowedRoom(room.name, @responders[name].rooms)
        room.speak(response.speak) if response.speak
        room.paste(response.paste) if response.paste
        room.sound(response.sound) if response.sound

    handler = @responders[name].handler
    intervals = []

    for method, tick of handler.intervals || []
      callback = => respond(handler.interval(method, respond))
      intervals.push = setInterval(callback, tick)

    @responders[name].intervals = intervals


  getUser: (userId, callback) ->
    @users.findById(userId, callback)


  isAllowedRoom: (name, rooms) ->
    return true unless rooms
    if _(rooms).isArray() then rooms.indexOf(name) > -1
    else if _(rooms).isRegExp() then name.match(rooms)
    else if _(rooms).isString() then name == rooms
    else true


  isMutedRoom: (room, callback) =>
    redis.exists "#{room.id}-muted", (err, silenced) =>
      @rooms[room.id].silenced = !!silenced
      callback(!!silenced)


  isCommandMessage: (message) ->
    return false unless message
    command = message.replace(@respondsToRegexp, '', '')
    return false if command == message
    command


  receivedMessage: (room, message) ->
    return unless message.userId
    return if @constructor.bots[message.userId]

    @getUser message.userId, (user) =>
      message.user = user
      message.room = id: room.id, name: room.name

      @isMutedRoom(room, => @delegateResponse(room, user, message))


  delegateResponse: (room, user, message) ->
    info = "\033[32m#{room.name}\033[37m/\033[35m#{user.fullName}"

    if message.type == 'EnterMessage'
      @log("#{info}\033[37m: \033[90mEntered the room")
      @respondToEnter(room, user)
    else if message.type == 'KickMessage'
      @log("#{info}\033[37m: \033[90mExited the room")
      @respondToLeave(room, user)
    else if message.body
      message.command = false
      message.original = message.body
      if command = @isCommandMessage(message.body)
        message.body = command
        message.command = true

      return if room.silenced && !message.command

      @processMessage room, message, (message) =>
        if @isAllowedRoom(room.name, @config.logRooms)
          @log("#{info}\033[37m: \033[90m#{JSON.stringify(message)}")
        @respondToMessage(room, user, message)
        user.lastMessage =
          body: message.body
          sentAt: new Date()
          roomName: message.room.name


  processMessage: (room, original, callback) ->
    message =
      body: original.body
      original: original.original
      type: original.type
      tweet: original.tweet
      user: original.user
      room: original.room
      command: original.command
      responses: 0
      intent: ''
      confidence: 0.0
      entities: {}
      sentiment: 0
      comparative: 0

    Sentiment message.body, (err, result = {}) =>
      if result
        message.sentiment = result.score
        message.comparative = result.comparative

      if message.command || room.confirms[message.user.id]
        @parseMessageOptions(message, callback)
      else
        callback(message)


  parseMessageOptions: (message, callback) ->
    if Wit.token && !@config.rawCommands
      Wit.message(message.body)
      .fail(-> callback(message))
      .then (res) ->
        message.intent = res.intent
        message.confidence = res.confidence
        message.entities = res.entities
        callback(message)
    else
      if match = message.body.match(/^([\w|:]+)\s+(.*)/i)
        message.body = match[1]
        for arg, i in (match[2] || '').match(/"[^"]+"|[^\s]+/gi) || []
          message.entities[i] = value: arg.replace(/^"|"$/, '')
      callback(message)


  respondToEnter: (room, user) ->
    respond = (response) => @sendResponse(room, user, response)

    for name, responder of @responders
      continue unless @isAllowedRoom(room.name, responder.rooms)
      try respond(responder.handler.respondToEvent?('enter', user, respond))
      catch e
        @log(e, 'error')


  respondToLeave: (room, user) ->
    respond = (response) => @sendResponse(room, user, response)

    for name, responder of @responders
      continue unless @isAllowedRoom(room.name, responder.rooms)
      try respond(responder.handler.respondToEvent?('leave', user, respond))
      catch e
        @log(e, 'error')


  respondToMessage: (room, user, message) ->
    respond = (response) => @sendResponse(room, user, response)

    if callback = room.confirms[user.id]
      delete(room.confirms[user.id])
      confirmed = message.body.match(/yes/) || message.intent == "true"
      respond(callback(confirmed, message, respond))
      return

    if callback = room.prompts[user.id]
      delete(room.prompts[user.id])
      respond(callback(message, respond))
      return

    for name, responder of @responders
      continue unless @isAllowedRoom(room.name, responder.rooms)
      continue unless responder.handler.respondsTo?(message)

      try
        respond(responder.handler.respond?(message, @users, respond))
      catch e
        @log(e, 'error')
        console.log(e.stack)
      finally
        message.responses += 1


  sendResponse: (room, user, response) ->
    return unless _(response).isObject()
    room.speak(response.speak) if response.speak
    room.paste(response.paste) if response.paste
    room.sound(response.sound) if response.sound
    if _(response.confirm).isFunction()
      return room.confirms[user.id] = response.confirm
    if _(response.prompt).isFunction()
      return room.prompts[user.id] = response.prompt



class UserRegistry

  constructor: (@key, @client) ->
    @users = {}

    redis.hgetall @key, (err, records) =>
      return unless records

      for token, key of records
        do(token, key) =>
          redis.hgetall key, (err, record) =>
            return unless record || record.value
            record = JSON.parse(record.value)
            @users[token] = record


  findById: (userId, callback) ->
    return callback?(@users[userId]) if @users[userId]

    @client.user userId, (err, user) =>
      name = (user ||= user: {name: "Unknown"}).user.name
      names = name.split(' ')
      initials = ''
      initials += n[0] for n in names

      @users[userId] =
        id: userId
        initials: initials
        name: names[0]
        lastName: names[1]
        fullName: name

      key = "#{@key}-#{userId}"
      redis.hset @key, userId, key, =>
        redis.hmset(key, value: JSON.stringify(@users[userId]))

      @users[userId].lastMessage = {}
      callback?(@users[userId])


  find: (ref) ->
    # todo: this should return something else if there's more than one match.
    return unless ref
    ref = ref.toLowerCase()
    _(@users).find (user) ->
      user.id == ref ||
      user.initials.toLowerCase() == ref ||
      user.name.toLowerCase() == ref ||
      user.fullName.toLowerCase() == ref



module.exports = Bitbot
