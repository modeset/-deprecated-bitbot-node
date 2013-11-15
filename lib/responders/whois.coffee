whois = require('node-whois')

class Responder extends Bitbot.BaseResponder

  responderName: "WhoIs"
  responderDesc: "Perform a WHOIS search."

  commands:
    whois:
      desc: "Performs a whois command for a given domain"
      examples: ["whois modeset.com"]
      opts:
        domain: type: "string", entity: "url"

  whois: (domain, callback) ->
    unless domain
      return speak: "Sorry #{@message.user.initials}, you need to provide a domain for this command."
    whois.lookup domain, timeout: 5000, (err, response) ->
      return callback(speak: err) if err
      response = response.replace(/[\s\n]+Corporation(.*)\n+/g, '')
      response = response.replace(/[\s\n]?Contact(.*)\n+/g, '')
      response = response.replace(/[\s\n]?NOTICE:(.*)\n+/g, '')
      response = response.replace(/[\s\n]?The data(.*)\n+/g, '')
      response = response.replace(/[\s\n]?We reserve(.*)\n+/g, '')
      response = response.replace(/[\s\n]?Get Noticed(.*)\n+/g, '')
      response = response.replace(/[\s\n]+|[\s\n+]+$/, '')
      callback(paste: "🆔 WHOIS #{domain}\n\n#{response}")


module.exports = new Responder()
