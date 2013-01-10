_ = require('underscore')
Shred = require('shred')
shred = new Shred()

exports.helpMessage = "Give you a UNIX fortune when you say 'fortune me'"

exports.receiveMessage = (message, room, bot) ->
  if message.body and /fortune me$/.test( message.body )
    shred.get(url: 'http://www.fortunefortoday.com/getfortuneonly.php').on 200, (response) ->
      room.paste response.content.body.trim()
