class Responder extends Bitbot.BaseResponder

  responderName: "Magic 8-Ball"
  responderDesc: "The Syco-Seer."

  commandPrefix: "magic"

  commands:
    '8ball':
      desc: "Ask the all mighty 8-ball for an answer to your question"
      examples: ["8ball me.", "magic 8 ball says?"]
      intent: "magic8ball"

  templates:
    result: "🎱 {{&initials}}, {{&response}}"

  responses: [
    "it is certain!",
    "it is decidedly so!",
    "without a doubt!",
    "yes definitely!",
    "you may rely on it!",
    "as I see it yes!",
    "most likely.",
    "outlook good.",
    "yes!",
    "signs point to yes.",
    "reply hazy try again.",
    "ask again later.",
    "better not tell you now.",
    "cannot predict now.",
    "concentrate and ask again.",
    "don't count on it.",
    "my reply is no.",
    "my sources say no.",
    "outlook not so good.",
    "very doubtful."
  ]


  '8ball': ->
    speak: @t('result', response: @random())



module.exports  = new Responder()
