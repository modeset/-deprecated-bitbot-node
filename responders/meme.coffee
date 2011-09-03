wwwdude = require("wwwdude")

json_client = wwwdude.createClient({
    contentParser: wwwdude.parsers.json
})

exports.helpMessage = "make you a fresh meme when you say 'meme'"

exports.receiveMessage = (message, room) ->
  if message.body and message.body.match(/meme/)
    json_client.get('http://api.automeme.net/text.json?lines=1').on('success', (data, response) ->
      room.speak(data[0])
    )