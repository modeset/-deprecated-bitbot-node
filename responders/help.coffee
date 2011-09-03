exports.receiveMessage = (message, room, client) ->
  if message.body and message.body.match(/what up bot?/)
    helpMsg = 'yo dawg. need some help? i can: \n\n'
    for responder in client.responders
      do(responder) ->
        if responder.helpMessage
          helpMsg += responder.helpMessage + '\n'

    room.speak(helpMsg)
