_ = require 'underscore'

exports.receiveMessage = (message, room, bot) ->
  if message.body and message.body.match(/what up bot|wat up bot|help bit bot/i)
    room.speak "Yo dawg. Need some help? Here's what I can do:"
    helps = (responder.helpMessage for name, responder of bot.responders)
    room.paste _(helps).compact().join("\n\n")
