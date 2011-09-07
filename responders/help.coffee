exports.receiveMessage = (message, room, client) ->
  helps = "yo dawg. need some help? here's what i can do:\n"
  if message.body and message.body.match(/what up bot|help bit bot/)
    for responder in client.responders
        if responder.helpMessage
          helps += responder.helpMessage + '\n'
  room.speak(helps)
