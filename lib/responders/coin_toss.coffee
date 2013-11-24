class Responder extends Bitbot.BaseResponder

  responderName: "Coin Toss"
  responderDesc: "Provides a command to flip a coin."

  commandPrefix: "coin"

  commands:
    toss:
      desc: "Flips a coin and provides the result"
      examples: ["heads or tails?", "flip a coin.", "coin toss."]
      intent: "cointoss"

  responses: [
    "Heads."
    "Tails."
  ]


  toss: ->
    speak: @random()



module.exports  = new Responder()
