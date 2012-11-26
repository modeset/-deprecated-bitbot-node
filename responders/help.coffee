_ = require 'underscore'

exports.receiveMessage = (message, room, bot) ->
  if message.body and message.body.match(/what up bot|help bit bot/)
    room.speak "yo dawg. need some help? here's what i can do:"
    helps = (responder.helpMessage for name, responder of bot.responders)
    room.paste _(helps).compact().join("\n")
