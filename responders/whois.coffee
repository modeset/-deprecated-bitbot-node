whois = require '../lib/whois'

exports.receiveMessage = (message, room, client) ->
  match = message.body.match(/whois (\S*)/)
  if match
    who = new whois.Whois()
    who.query match[1], (response) ->
      room.paste response.toString()