exports.responseUrl = "http://www.lolbrary.com/lolpics/903/haters-gonna-hate-unicorn-bike-edition-6903.jpg"

exports.receiveMessage = (message, room, client) ->
  haters_regex = /hater/
  room.speak exports.responseUrl if message.userId != client.bitBotId and message.body and message.body.match(haters_regex)

