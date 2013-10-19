#whois = require '../../lib/whois'
whois = require 'node-whois'

exports =
  helpMessage: "Perform a WHOIS search when you say 'whois <domain>'"
  respond: (message, room) ->
    return unless message.body && message.body.match(/whois (\S*)$/)
    whois.lookup match[1], (response) ->
      room.paste response.toString()
