exports.receiveMessage = (message, room, client) ->
  if message.body and message.body.match(/what up bot|help bit bot/)
    room.speak "yo dawg. need some help? here's what i can do:"
    for responder in client.responders
      do(responder) ->
        room.speak(responder.helpMessage) if responder.helpMessage?
