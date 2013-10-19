extend = require('node.extend')

class Bitbot

  @loadConfiguration: ->



  constructor: (options = {}) ->
    extend(@, options)
    @connect()
    @bindPeriodics()
    @bindResponders()


  connect: ->
    @client = new Campfire(ssl: true, token: @cfToken, account: @cfAccount)
    @client.me (error, response) =>
      console.log 'Got bot info', response.user
      @botUserId = response.user.id
      @botUserName = response.user.name


  reload: ->
    console.log 'Reloading the bot'
    @unbindPeriodics()
    @unbindResponders()
    @bindPeriodics()
    @bindResponders()


  bindPeriodics: =>
    @periodicTimers = []
    @activeRooms (room) =>
      for name, periodic of @constructor.all_periodics
        console.log("binding timer: #{name}")
        @periodicTimers.push(periodic.bind(room))


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



#
#
#  respondToMessage: (room, message) =>
#    console.log room.name + ': heard ' + message.body + ' from ' + message.userId
#
#    # Abort if this is a presence message or from the bot itself
#    return if !(message?.body) or message.userId is @botUserId
#
#    for name, responder of @responders
#      do (name, responder) =>
#        if message.body.match(new RegExp("^[@]?(?:#{@name}[:,]?|#{@botUserName}[:,]?)"))
#          responder.respond?(message, room, @)
#        else
#          @roomHasEarmuffs room, (result) =>
#            if result
#              console.log "Ignoring conversational responders since #{room.name} is earmuffed"
#            else
#              responder.hear?(message, room, @)
#
#
#  #
#  # Private
#  #
#
#  activeRooms: (callback) =>
#    @client.rooms (error, rooms) =>
#      for room in rooms
#        do (room) =>
#          return if room
#          callback.call(@, room) unless @ignored_room_regex && room.name.match(@ignored_room_regex)
#
#
#  roomHasEarmuffs: (room, callback) =>
#    @redis.exists "#{room.id}-muted", (err, res) =>
#      callback.call @, (res is 1)
#
#
#  earmuffs: (room, time = 300) =>
#    key = "#{room.id}-muted"
#    @redis.set key, true
#    @redis.expire key, time
#

module.exports = Bitbot
