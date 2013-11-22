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

    @respondsTo = @config.respondsTo || []
    @respondsTo = [@respondsTo] unless _(@respondsTo).isArray()
    @respondsTo.push(@user.name)

    @log("Connected (\033[33m#{user.id}\033[37m)")
    @log("Responding to \033[35m#{@respondsTo.join(', ')}")

    @initialize()


  initialize: ->
    @joinRooms()
    @loadResponders()


  reload: ->
    room.speak("BRB") for id, room of @rooms

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
      ids = if response.roomId then [response.roomId] else Object.keys(@rooms)
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
    @users ||= {}

    return callback?(@users[userId]) if @users[userId]

    @client.user userId, (err, user) =>
      name = (user ||= user: {name: "Unknown"}).user.name
      names = name.split(' ')
      initials = ''
      initials += n[0] for n in names

      @users[userId] =
        name: names[0]
        fullName: name
        initials: initials
        lastMessage: ''
        id: userId

      callback?(@users[userId])


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
    bRegexp = new RegExp("^(#{@respondsTo.join('|')})[:,;]?\\s+", 'gi')
    aRegexp = new RegExp("(\\s+)(#{@respondsTo.join('|')})(?:\\b)", 'gi')
    command = message.replace(bRegexp, '', '')
    return false if command == message && !message.match(aRegexp)
    command


  receivedMessage: (room, message) ->
    return unless message.userId
    return if @constructor.bots[message.userId]

    @getUser message.userId, (user) =>
      message.user = user
      message.room = id: room.id, name: room.name

      @isMutedRoom(room, => @delegateResponse(room, user, message))


  processMessage: (original, callback) ->
    message =
      body: original.body
      type: original.type
      tweet: original.tweet
      user: original.user
      room: original.room
      command: original.command

    Sentiment message.body, (err, result = {}) ->
      if result
        message.sentiment = result.score
        message.comparative = result.comparative

      if Wit.token && message.command
        Wit.message(message.body)
        .fail(-> callback(message))
        .then (res) ->
            message.intent = res.intent
            message.confidence = res.confidence
            message.entities = res.entities
            callback(message)
      else
        message.intent = ""
        message.confidence = 0.0
        message.entities = {}
        callback(message)


  delegateResponse: (room, user, message) ->
    info = "\033[32m#{room.name}\033[37m/\033[35m#{user.fullName}"

    if message.type == 'EnterMessage'
      @log("#{info}\033[37m: \033[90mEntered the room")
      @respondToEnter(room, user)
    else if message.type == 'KickMessage'
      @log("#{info}\033[37m: \033[90mExited the room")
      @respondToLeave(room, user)
    else if message.body
      message.responses = 0
      message.original = message.body
      message.command = false
      if command = @isCommandMessage(message.body)
        message.body = command
        message.command = true

      return if room.silenced && !message.command

      @processMessage message, (message) =>
        if @isAllowedRoom(room.name, @config.logRooms)
          @log("#{info}\033[37m: \033[90m#{JSON.stringify(message)}")
        @respondToMessage(room, user, message)
        user.lastMessage = message.body


  respondToEnter: (room, user) ->
    respond = (response) => @sendResponse(room, user, response)

    for name, responder of @responders
      continue unless @isAllowedRoom(room.name, responder.rooms)
      try respond(responder.handler.event?('enter', user, respond))
      catch e
        @log(e, 'error')


  respondToLeave: (room, user) ->
    respond = (response) => @sendResponse(room, user, response)

    for name, responder of @responders
      continue unless @isAllowedRoom(room.name, responder.rooms)
      try respond(responder.handler.event?('leave', user, respond))
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

      try respond(responder.handler.respond?(message, respond))
      catch e
        @log(e, 'error')
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


module.exports = Bitbot
