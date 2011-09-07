exports.receiveMessage = (message, room, client) ->
  hello_regex = /hello bit bot|yo dawg|sup bit bot|morning bit bot/
  results = ['yo dawg', '0110100001101001', 'well hello there']
  random = results[Math.floor(Math.random() * results.length)]
  room.speak "yo dawg" if message.userId != client.bitBotId and message.body and message.body.match(hello_regex)
