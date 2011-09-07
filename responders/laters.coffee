exports.receiveMessage = (message, room, client) ->
  hello_regex = /laters bit bot|night bit bot/
  room.speak "g'night slacker" if message.userId != client.bitBotId and message.body and message.body.match(hello_regex)
