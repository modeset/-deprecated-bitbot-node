class Responder extends Bitbot.RegexpResponder

  regexp: /rimshot/

  randomResponse: ->
    sound: 'rimshot'


module.exports = new Responder()
