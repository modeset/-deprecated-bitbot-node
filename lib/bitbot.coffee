class Bitbot

  # Base Commands

  @UntrustedCommand: require('./bitbot/base_commands/untrusted_command')

  # Base Periodics

  @UntrustedPeriodic: require('./bitbot/base_periodics/untrusted_periodic')

  # Base Responders

  @SimpleResponder: require('./bitbot/base_responders/simple_responder')
  @UntrustedResponder: require('./bitbot/base_responders/untrusted_responder')

  # Base Periodics

  @UntrustedPeriodic: require('./bitbot/base_periodics/untrusted_periodic')

  # Core Extensions

  @log: require('./bitbot/logger')
  @load: require('./bitbot/loader')

  # Class variables / methods

  @logPrefix: 'Core:'
  @bots: {}

  @createFromConfig: (@configPath) ->
    @load @configPath, name: 'configuration', (err, content) ->
      if (err)
        @log(err.message, 'error')
        process.exit()

      for name, config of JSON.parse(content)
        Bitbot.verify config, (config, token, account) ->
          Bitbot.create(name, config, token, account)


  @verify: (config, callback) ->
    account = process.env.CAMPFIRE_ACCOUNT
    token = config.token

    if !token
      @log("You must specify a token for #{name}", 'error')
      return

    if token.match(/^>/) && !token = process.env[env = token.replace(/^>/, '')]
      @log("You must specify a token for #{env} in your environment", 'error')
      return

    callback(config, token, account)


  @create: (name, config, token, account) ->
    @log("Creating bot #{name}")

    client = new Campfire(ssl: true, account: account, token: token)
    client.me (err, response) =>
      if err
        @log("Unable to connect to campfire (#{err.message})", 'error')
        return
      console.log(name)
      @bots[response.user.id] = new Bitbot(client, name, response.user, config)

  # Instance methods

  log: @log
  load: @load

  constructor: (@client, @name, @user, @config) ->
    @logPrefix = "#{@user.name}:"

    @respondsTo = @config.respondsTo || @user.name
    @respondsTo = [@respondsTo] unless _(@respondsTo).isArray()

    @log("Connected (#{user.id} -- #{@respondsTo.join(', ')})")

    @initialize()


  initialize: ->
    @joinRooms()
    @loadCommands()
    @loadResponders()
    @loadPeriodics()


  reload: ->
    room.speak("Reloading...") for id, room of @rooms
    @load Bitbot.configPath, name: 'configuration', (err, content) =>
      if (err)
        @log(err.message, 'error')
        return

      for name, config of JSON.parse(content)
        continue unless name == @name
        Bitbot.verify config, (config, token, account) =>
          @config = config
          @initialize()


  joinRooms: ->
    @rooms ||= {}

    joinOrLeave = (room, allowed) =>
      if allowed && !@rooms[room.id]
        @log("Joining #{room.name}")

        (@rooms[room.id] = room).join =>
          room.listen room.listener = (message) =>
            @respondTo(room, message)

#      else if @rooms[room.id]
#        @log("Leaving #{room.name}")
#
#        room.listener.abort()
#        room.leave()
#        delete(@rooms[room.id])

    @client.rooms (err, rooms) =>
      if err
        @log('Unable to get room list', 'error')
        return

      for room in rooms
        joinOrLeave(room, @isAllowedRoom(room.name, @config.rooms))


  loadCommands: ->
    @commands = {}

    for name, command of @config.commands || {}
      opts = name: "#{name} command"
      @loadResource name, command, opts, (name, command, handler) =>
        handler = new Bitbot.UntrustedCommand(name, handler) if _(handler).isString()
        @commands[name] =
          handler: handler
          rooms: command.rooms || true


  loadResponders: ->
    @responders = {}

    for name, responder of @config.responders || {}
      opts = name: "#{name} responder"
      @loadResource name, responder, opts, (name, responder, handler) =>
        handler = new Bitbot.UntrustedResponder(name, handler) if _(handler).isString()
        @responders[name] =
          handler: handler
          rooms: responder.rooms || true


  loadPeriodics: ->
    for name, periodic of @periodics || {}
      clearInterval(perodic.interval)

    @periodics = {}

    for name, periodic of @config.periodics || {}
      opts = name: "#{name} periodic"
      @loadResource name, periodic, opts, (name, periodic, handler) =>
        handler = new Bitbot.UntrustedPeriodic(name, handler) if _(handler).isString()
        tick = (periodic.tick || 5 * 60) * 1000

        out = (res) =>
          return unless _(res).isObject()
          for id, room of @rooms
            continue unless @isAllowedRoom(room.name, @periodics[name].rooms)
            room.speak(res.speak) if res.speak
            room.paste(res.paste) if res.paste

        @periodics[name] =
          handler: handler
          rooms: periodic.rooms || true
          interval: setInterval((-> out(handler.main(out))), tick)


  loadResource: (name, resource, options = {}, callback = ->) ->
    # todo: should load from more than one path -- checking in a few places
    source = resource.url || Path.join(root, resource.file || resource)
    options.trusted = true if _(resource).isString()

    @load source, _(options).extend(resource), (err, handler) =>
      if err
        @log("#{name} - #{err.message}", 'error')
        return

      callback(name, resource, handler)


  # message handling

  respondTo: (room, message) ->
    return unless message && message.body
    return if @constructor.bots[message.userId]

    message.roomName = room.name

    if command = @isCommand(message.body)
      message.body = command
      @log("#{room.name}: responding to command #{message.body} (#{message.userId})")
      @processMessage message, (message) => @respondToCommand(room, message)
    else
      @log("#{room.name}: responding to message #{message.body} (#{message.userId})")
      @roomIsSilenced room, (result) =>
        return if result
        @processMessage message, (message) => @respondToMessage(room, message)


  isCommand: (message) ->
    command = message.replace(new RegExp("^(#{@respondsTo.join('|')})[:,]?\\s+", 'gi'), '', '')
    return false if command == message
    command


  processMessage: (message, callback) ->
    msg =
      body: message.body,
      type: message.type,
      userId: message.userId,
      roomId: message.roomId,
      tweet: message.tweet,
      roomName: message.roomName

    if Wit.token
      promise = Wit.message(msg.body)
      promise.fail -> callback(msg)
      promise.then (response) ->
        _(msg).extend(response)
        callback(msg)
    else
      callback(msg)


  respondToCommand: (room, message) ->
    return if @respondToInternalCommand(room, message)

    out = (res) ->
      return unless _(res).isObject()
      room.speak(res.speak) if res.speak
      room.paste(res.paste) if res.paste

    respond = (name, command) =>
      output = command.handler.main(message, out)
      out(output)

    for name, command of @commands
      continue unless @isAllowedRoom(room.name, command.rooms)
      respond(name, command)


  respondToInternalCommand: (room, message) ->
    if message.body == 'silence!' || (message.intent == 'silence' && message.confidence > 0.7)
      room.speak("I'm sorry.. I'll be quite for a while.")
      redis.set("#{message.roomId}-muted", true)
      redis.expire("#{message.roomId}-muted", time)

    else if message.body == 'resume!' || (message.intent == 'unsilence' && message.confidence > 0.7)
      room.speak('Thanks!')
      redis.del("#{message.roomId}-muted", true)

    else if message.body == 'reload!' || (message.intent == 'reload' && message.confidence > 0.7)
      @reload()
      callback(speak: 'Done reloading. It may be a bit before you see me joining or leaving rooms etc.')

    else if message.body == 'help!' || (message.intent == 'help' && message.confidence > 0.7)
      room.paste """
      Commands:
        - help! - you're looking at it
        - reload! - I'll reload the configuration and reinitialize
        - silence! - I'll be silent for a while and will only respond to commands
        - resume! - Lets me resume after being silenced
      """


  respondToMessage: (room, message) ->
    out = (res) ->
      return unless _(res).isObject()
      room.speak(res.speak) if res.speak
      room.paste(res.paste) if res.paste

    respond = (name, responder) =>
      output = responder.handler.main(message, out)
      out(output)

    for name, responder of @responders
      continue unless @isAllowedRoom(room.name, responder.rooms)
      respond(name, responder)


  isAllowedRoom: (name, rooms) ->
    return true unless rooms
    if _(rooms).isArray() then rooms.indexOf(name) > -1
    else if _(rooms).isRegExp() then name.match(rooms)
    else if _(rooms).isString() then name == rooms
    else true


  roomIsSilenced: (room, callback) =>
    redis.exists "#{room.id}-muted", (err, res) =>
      callback(res == 1)


module.exports = Bitbot
