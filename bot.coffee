# Load libraries
ranger  = require("ranger")
express = require("express")
wwwdude = require("wwwdude")
sys     = require("sys")
Sandbox = require('sandbox')

# Reusable objects
client = ranger.createClient(process.env.CAMPFIRE_ACCOUNT, process.env.CAMPFIRE_TOKEN)
app = express.createServer(express.logger())

json_client = wwwdude.createClient({
    contentParser: wwwdude.parsers.json
})

sandbox = new Sandbox()

# Set up the express listener
app.get('/', (request, response) ->
  response.send('bleep bloop')
)

port = process.env.PORT || 3000

app.listen(port, ->
  console.log("Listening on " + port)
)

# Set up the Campfire room listeners
client.rooms((rooms) ->
  for room in rooms
    do (room) ->
      room.join()
      console.log('Joined ' + room.name)
      room.listen((message) ->
        console.log('Heard ' + message.body + ' from ' + message.userId)

        if message.body and message.body.match(/meme|what's up/)
          json_client.get('http://api.automeme.net/text.json?lines=1').on('success', (data, response) ->
            room.speak(data[0])
          )

        if message.body and /^eval (.+)/.test( message.body )
          sandbox.run /^eval (.+)/.exec(message.body)[1], ( output ) ->
            room.speak(output.result.replace( /\n/g, ' ' ))
      )
      console.log('Listening to ' + room.name)
)