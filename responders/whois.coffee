whois = require('../lib/whois');

exports.receiveMessage = (message, room, client) ->
  match = message.body.match(/whois (\S*)/)
  if match
    who = new whois.Whois();
    who.query match[0], (response) ->
      room.paste response