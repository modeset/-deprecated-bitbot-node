exports.responses = ['yo dawg', '0110100001101001', 'well hello there']

exports.receiveMessage = (message, room, client) ->
  hello_regex = /hello bit(\s?)bot|yo dawg|sup bit(\s?)bot|morning bit(\s?)bot/
  results = exports.responses
  random = results[Math.floor(Math.random() * results.length)]
  room.speak random if message.userId != client.bitBotId and message.body and message.body.match(hello_regex)
