wwwdude = require("wwwdude")

json_client = wwwdude.createClient({
  contentParser: wwwdude.parsers.json
})

exports.helpMessage = "generate you a fresh new password when you say 'make me a password'"

exports.receiveMessage = (message, room, client) ->
  if message.body and /^make me a password/.test( message.body )
   json_client.get('http://fishsticks.herokuapp.com/?wordlist=propernames').on('success', (data, response) ->
      room.speak('Try this one: ' + data)
    )