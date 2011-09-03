ranger = require("ranger")
express = require("express")
wwwdude = require("wwwdude")
sys = require("sys")

creds =
  account: "bittheory"
  api_key: "7d0bcc5744c0794e0fdaa47bb209151060039982"

client = ranger.createClient(creds.account, creds.api_key)
app = express.createServer(express.logger())

json_client = wwwdude.createClient({
    contentParser: wwwdude.parsers.json
})

app.get('/', (request, response) ->
  response.send('bleep bloop')
)

port = process.env.PORT || 3000

app.listen(port, ->
  console.log("Listening on " + port)
)

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
      )
      console.log('Listening to ' + room.name)
#      room.speak('hello world!') if room.name == 'Bits'
)