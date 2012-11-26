whois = require '../lib/whois'

exports.helpMessage = "Perform a WHOIS search when you say 'whois <domain>'"

exports.receiveMessage = (message, room, bot) ->
  match = message.body && message.body.match(/^whois (\S*)$/)
  if match
    who = new whois.Whois()
    who.query match[1], (response) ->
      room.paste response.toString()
