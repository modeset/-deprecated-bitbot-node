class Responder extends Bitbot.BaseResponder

  url: "http://fishsticks.herokuapp.com/?wordlist=propernames"

  responderName: "Password"
  responderDesc: "Generates a readable password from a wordlist."

  commandPrefix: "password"

  commands:
    generate:
      desc: "Generate a password"
      examples: ["I need a password.", "generate a password for me."]
      intent: "passwordgenerate"

  templates:
    error: "Sorry {{&initials}}, the password service isn't working. :("
    generate: "🔒 {{&initials}}, here's a password: {{&password}}"


  generate: (callback) ->
    request @url, (err, response, body) =>
      return callback(speak: @t('error')) if err
      callback(speak: @t('generate', password: body))



module.exports = new Responder()
