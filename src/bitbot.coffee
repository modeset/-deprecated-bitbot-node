class Bitbot

  constructor: (@name, @client, @responders, @periodics, @redis, @ignored_room_regex) ->
    @periodicTimers = []
    @responderBindings = []
    @getOwnInfo()
    @bindPeriodics()
    @bindResponders()

    # Reload the bot every 30 minutes
    # Disabled for now because the campfire lib doesn't return the info we need to unbind listeners properly
    # @reloadInterval = setInterval(@reload, 30 * 60 * 1000)


  reload: =>
    console.log 'Reloading the bot'
    @unbindPeriodics()
    @unbindResponders()
    @bindPeriodics()
    @bindResponders()


  getOwnInfo: =>
    @client.me (error,response) =>
      user = response.user
      console.log 'Got bot info', user
      @botUserId = user.id
      @botUserName = user.name


  bindPeriodics: =>
    @periodicTimers = []
    @activeRooms (room) =>
      @periodicTimers.push(periodic.bind(room)) for name, periodic of @periodics


  unbindPeriodics: =>
    clearInterval(timer) for timer in @periodicTimers


  bindResponders: =>
    @responderBindings = []
    @activeRooms (room) =>
      room.join =>
        @responderBindings.push room.listen (message) =>
          @respondToMessage(room, message)
        console.log 'Listening to ' + room.name


  unbindResponders: =>
    binding?.abort() for binding in @responderBindings
    true


  respondToMessage: (room, message) =>
    console.log room.name + ': heard ' + message.body + ' from ' + message.userId

    # Abort if this is a presence message or from the bot itself
    return if !(message?.body) or message.userId is @botUserId

    for name, responder of @responders
      if message.body.match(new RegExp("^[@]?(?:#{@name}[:,]?|#{@botUserName}[:,]?)")) and typeof responder['respond'] is 'function'
        responder.respond(message, room, @)
      else if typeof responder['hear'] is 'function'
        @roomHasEarmuffs room, (result) =>
          if result
            console.log "Ignoring conversational responders since #{room.name} is earmuffed"
          else
            responder.hear(message, room, @)


  #
  # Private
  #

  activeRooms: (callback) =>
    @client.rooms (error, rooms) =>
      for room in rooms
        do (room) =>
          callback.call(@, room) unless room.name.match(@ignored_room_regex)

  roomHasEarmuffs: (room, callback) =>
    @redis.exists "#{room.id}-muted", (err, res) =>
      callback.call @, (res is 1)

  earmuffs: (room, time = 300) =>
    key = "#{room.id}-muted"
    @redis.set key, true
    @redis.expire key, time


module.exports = Bitbot
