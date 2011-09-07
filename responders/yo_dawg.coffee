exports.receiveMessage = (message, room, client) ->
  hello_regex = /hello bit bot|yo dawg|sup bit bot|morning bit bot/
  room.speak "yo dawg" if message.body and message.body.match(hello_regex)
