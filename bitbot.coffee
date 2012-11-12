class Bitbot

  constructor: (@client, @responders, @redis, @ignored_room_regex) ->
    @getBotInfo()
    @bind()

  getOwnInfo: =>
    @client.me (error,response) =>
      user = response.user
      console.log 'Got bot info', user
      @botUserId = user.id

  bind: =>
    @client.rooms (error, rooms) =>
      for room in rooms
        do (room) =>
          unless room.name.match(@ignored_room_regex)
            room.join ->
              console.log 'Joined ' + room.name
              room.listen (message) ->
                console.log room.name + ': heard ' + message.body + ' from ' + message.userId
                responder.receiveMessage(message, room, @) for name, responder of @responders
              console.log 'Listening to ' + room.name

module.exports = Bitbot
