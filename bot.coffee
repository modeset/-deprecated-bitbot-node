# Load libraries
ranger  = require("ranger")

# Reusable objects
client = ranger.createClient(process.env.CAMPFIRE_ACCOUNT, process.env.CAMPFIRE_TOKEN)

# Set up the Campfire room listeners

client.responders = [
  require('./responders/js_sandbox'),
  require('./responders/meme')
  require('./responders/help'),
  require('./responders/password')
  require('./responders/twss')
  require('./responders/weather')
  require('./responders/foursquare')
]

client.rooms((rooms) ->
  for room in rooms
    do (room) ->
      room.join()
      console.log('Joined ' + room.name)
      room.listen((message) ->
        console.log('Heard ' + message.body + ' from ' + message.userId)
        for responder in client.responders
          do (responder) ->
            responder.receiveMessage(message, room, client)
      )
      console.log('Listening to ' + room.name)
      room.speak "Have no fear, Bitbot is here"
)