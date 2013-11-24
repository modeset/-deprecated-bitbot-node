whois = require('node-whois')

class Responder extends Bitbot.BaseResponder

  responderName: "WhoIs"
  responderDesc: "Perform a WHOIS search."

  commands:
    whois:
      desc: "Performs a whois command for a given domain"
      examples: ["whois modeset.com"]
      opts:
        domain: {type: "string", entity: "url"}

  templates:
    missingDomain: "Sorry {{&initials}}, you need to provide a domain for this command."
    error: "Sorry {{&name}}, I wasn't able to find that information. :("
    whois: "🆔 WHOIS {{domain}}\n\n{{response}}"


  whois: (domain, callback) ->
    return {speak: @t('missingDomain')} unless domain

    whois.lookup domain, timeout: 5000, (err, response) =>
      return callback(speak: @t('error')) if err
      callback(paste: @t('whois', domain: domain, response: @sanitizeResponse(response)))


  sanitizeResponse: (response) ->
    response = response.replace(/[\s\n]+Corporation(.*)\n+/g, '')
    response = response.replace(/[\s\n]?Contact(.*)\n+/g, '')
    response = response.replace(/[\s\n]?NOTICE:(.*)\n+/g, '')
    response = response.replace(/[\s\n]?The data(.*)\n+/g, '')
    response = response.replace(/[\s\n]?We reserve(.*)\n+/g, '')
    response = response.replace(/[\s\n]?Get Noticed(.*)\n+/g, '')
    response = response.replace(/[\s\n]+|[\s\n+]+$/, '')
    response



module.exports = new Responder()
