Shred = require("shred")
shred = new Shred()

exports.helpMessage = "make you a fresh meme when you say 'meme'"

exports.receiveMessage = (message, room) ->
  if message.body and message.body.match(/meme/)
    shred.get('http://api.automeme.net/text.json?lines=1').on 200, (response) ->
      room.speak response.content.data[0]
