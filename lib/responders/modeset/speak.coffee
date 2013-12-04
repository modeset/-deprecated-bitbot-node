class Responder

  respondsTo: (message) ->
    return true if message.command && message.body.match(/^\[([\w|\s|*]+)\] (.*)/)
    false


  respond: (message) ->
    match = message.body.match(/^\[([\w|\s|\*]+)\] (.*)/)
    [room, msg] =[match[1], match[2]]

    if room == '*'
      rooms = _(@bot.rooms).values()
    else
      rooms = _(@bot.rooms).where(name: room)

    room.speak(msg) for room in rooms



module.exports = new Responder()
