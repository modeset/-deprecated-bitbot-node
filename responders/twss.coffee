exports.receiveMessage = (message, room, client) ->
  twss_regex = /big one|in yet|fit that in|long enough|take long|hard|pull|push|rough/
  room.speak "TWSS" if message.userId != client.bitBotId and message.body and message.body.match(twss_regex)
