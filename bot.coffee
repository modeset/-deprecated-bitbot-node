# Load libraries
ranger  = require("ranger")
express = require("express")

# Reusable objects
client = ranger.createClient(process.env.CAMPFIRE_ACCOUNT, process.env.CAMPFIRE_TOKEN)
app = express.createServer(express.logger())

# Set up the express listener
app.get('/', (request, response) ->
  response.send('bleep bloop')
)

port = process.env.PORT || 3000

app.listen(port, ->
  console.log("Listening on " + port)
)

# Set up the Campfire room listeners

client.responders = [
  require('./responders/js_sandbox'),
  require('./responders/meme')
  require('./responders/help'),
  require('./responders/password')
  require('./responders/twss')
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
)