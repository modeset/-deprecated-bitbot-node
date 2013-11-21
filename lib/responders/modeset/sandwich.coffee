class Responder extends Bitbot.BaseResponder

  responderName: "Sandwich"

  commands:
    sandwich: {}

  responses: [
    "*poof*, {{name}} is now a {{sudo}}sandwich."
    "If you're gonna be a smartass {{name}}, first you have to be smart. Otherwise you're just an ass."
  ]

  sandwich: ->
    @randomResponse(!!@message.body.match(/^sudo /))


  randomResponse: (sudo = false) ->
    response = @responses[Math.floor(Math.random() * @responses.length)]
    response = response.replace('{{name}}', @message.user.name)
    response = response.replace('{{sudo}}', if sudo then 'sudo ' else '')
    speak: response


module.exports  = new Responder()
