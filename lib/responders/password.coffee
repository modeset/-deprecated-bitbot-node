request = require('request')

class Responder extends Bitbot.BaseResponder

  responderName: "Password"
  responderDesc: "Generates a readable password from a wordlist."

  commandPrefix: 'password'

  commands:
    generate:
      desc: "Generate a password"
      examples: ["I need a password", "generate a password"]
      intent: "passwordgenerate"

  url: 'http://fishsticks.herokuapp.com/?wordlist=propernames'

  generate: (callback) ->
    request @url, (err, response, body) =>
      if err
        @log(err, 'error')
        callback(speak: "Sorry, #{@message.user.initials}, the password generating service isn't working. :(")

      callback(speak: "🔒 #{@message.user.initials}, here's a new password: #{body}")


module.exports = new Responder()
