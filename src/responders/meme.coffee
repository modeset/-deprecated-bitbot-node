Shred = require("shred")
shred = new Shred()

exports.helpMessage = "Make you a fresh meme when you say 'meme'"

exports.hear = (message, room, bot) ->
  if message.body and message.body.match(/meme/)
    shred.get(url: 'http://api.automeme.net/text.json?lines=1').on 200, (response) ->
      room.speak response.content.data[0]
