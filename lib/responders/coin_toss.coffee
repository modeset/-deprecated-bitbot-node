class Responder extends Bitbot.BaseResponder

  responderName: "Coin Toss"
  responderDesc: "Provides a command to flip a coin."

  commandPrefix: 'coin'

  commands:
    toss:
      desc: "Flips a coin"
      examples: ["heads or tails", "flip a coin", "coin toss"]
      intent: 'cointoss'

  responses: ["Heads", "Tails"]

  toss: ->
    speak: @responses[Math.floor(Math.random() * @responses.length)]

module.exports  = new Responder()
