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
    @logPrefix = "#{@user.name}:"

    @respondsTo = @config.respondsTo || @user.name
    @respondsTo = [@respondsTo] unless _(@respondsTo).isArray()

    @log("Connected (\033[33m#{user.id}\033[37m)")
    @log("Responding to \033[35m#{@respondsTo.join(', ')}")

    @initialize()


  initialize: ->
    @joinRooms()
    @loadResponders()


  reload: ->
    room.speak("BRB") for id, room of @rooms

    @load Bitbot.configPath, name: 'configuration', (err, content) =>
      return @log(err.message, 'error') if (err)

      for name, config of JSON.parse(content)
        continue unless name == @name
        Bitbot.verifyConfig config, (config, token, account) =>
          @config = config
          @initialize()


  joinRooms: ->
    @rooms ||= {}

    joinOrLeave = (room, allowed) =>
      if allowed
        return if @rooms[room.id]

        @log("Joining \033[32m#{room.name}")

        (@rooms[room.id] = room).join =>
          room.listen((message) => @respondTo(room, message))

      else if @rooms[room.id]
        @log("Leaving \033[32m#{room.name}")

        room.leave()
        delete(@rooms[room.id])

    @client.rooms (err, rooms) =>
      return @log('Unable to get room list', 'error') if err

      for room in rooms
        joinOrLeave(room, @isAllowedRoom(room.name, @config.rooms))


  loadResponders: ->
    for name, responder of @responder
      for interval in responder.intervals || []
        clearInterval(interval)

    @responders = {}

    for name, responder of @config.responders
      # todo: should load from more than one path -- checking in a few places
      source = responder.url || Path.join(root, 'lib', 'responders', responder.file || responder)

      opts =
        name: "#{name} responder",
        trusted: !responder.untrusted

      @load source, _(opts).extend(responder), (err, handler) =>
        return @log("#{name} - #{err.message}", 'error') if err

        handler.bot = @ if responder.core

        @responders[name] =
          handler: handler
          rooms: responder.rooms || true

        @addResponderIntervals(name) if handler.intervals


  addResponderIntervals: (name) ->
    respond = (res) =>
      return unless _(res).isObject()
      for id, room of @rooms
        continue unless @isAllowedRoom(room.name, @responders[name].rooms)
        room.speak(res.speak) if res.speak
        room.paste(res.paste) if res.paste

    handler = @responders[name].handler
    intervals = []
    for method, tick of handler.intervals || []
      callback = => respond(handler.interval(method, respond))
      intervals.push = setInterval(callback, tick)

    @responders[name].intervals = intervals


  getUser: (userId, callback) ->
    @users ||= {}

    if @users[userId]
      callback(@users[userId])
      return

    @client.user userId, (err, user) =>
      name = (user ||= user: {name: "Unknown"}).user.name
      names = name.split(' ')
      initials = ''
      initials += n[0] for n in names

      @users[userId] =
        name: names[0],
        fullName: name,
        initials: initials,
        lastMessage: ''

      callback(@users[userId])


  isAllowedRoom: (name, rooms) ->
    return true unless rooms
    if _(rooms).isArray() then rooms.indexOf(name) > -1
    else if _(rooms).isRegExp() then name.match(rooms)
    else if _(rooms).isString() then name == rooms
    else true


  isMutedRoom: (room, callback) =>
    redis.exists "#{room.id}-muted", (err, res) =>
      callback(res == 1)


  isCommandMessage: (message) ->
    startRegexp = new RegExp("^(#{@respondsTo.join('|')})[:,]?\\s+", 'gi')
    anyRegexp = new RegExp("(#{@respondsTo.join('|')})", 'gi')
    command = message.replace(startRegexp, '', '')
    return false if command == message && !message.match(anyRegexp)
    command


  respondTo: (room, message) ->
    return unless message && message.body
    return if @constructor.bots[message.userId]

    @getUser message.userId, (user) =>
      message.user = user
      message.room = id: room.id, name: room.name

      if command = @isCommandMessage(message.body)
        message.body = command
        message.command = true

      @isMutedRoom room, (result) =>
        return if result && !command

        @processMessage message, (message) =>
          info = "\033[32m#{room.name}\033[37m/\033[35m#{user.fullName}"
          @log("#{info}\033[37m: \033[90m#{JSON.stringify(message)}")

          @respondToMessage(room, message)
          user.lastMessage = message.body


  processMessage: (original, callback) ->
    message =
      body: original.body
      type: original.type
      tweet: original.tweet
      user: original.user
      room: original.room
      command: original.command

    Sentiment message.body, (err, result) ->
      if result
        message.sentiment = result.score
        message.comparative = result.comparative

      if Wit.token
        Wit.message(message.body)
        .fail(-> callback(message))
        .then (res) ->
            message.intent = res.intent
            message.confidence = res.confidence
            message.entities = res.entities
            callback(message)
      else
        callback(message)


  respondToMessage: (room, message) ->
    respond = (response) ->
      return unless _(response).isObject()
      room.speak(response.speak) if response.speak
      room.paste(response.paste) if response.paste

    for name, responder of @responders
      continue unless @isAllowedRoom(room.name, responder.rooms)
      continue unless responder.handler.respondsTo?(message)

      try respond(responder.handler.respond?(message, respond))
      catch e
        @log(e, 'error')


module.exports = Bitbot
