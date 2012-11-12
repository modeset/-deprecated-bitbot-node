Shred = require("shred")
shred = new Shred()

exports.helpMessage = "generate you a fresh new password when you say 'make me a password'"

exports.receiveMessage = (message, room, bot) ->
  if message.body and /^make me a password/.test( message.body )
   shred.get(url: 'http://fishsticks.herokuapp.com/?wordlist=propernames').on 200, (response) ->
      room.speak('Try this one: ' + response.content.data)
