exports.receiveMessage = (message, room, client) ->
  twss_regex = /big one|in yet|fit that in|long enough|take long|hard|rough|large/
  room.speak "TWSS" if message.userId != client.bitBotId and message.body and message.body.match(twss_regex)
