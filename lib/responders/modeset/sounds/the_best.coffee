class Responder extends Bitbot.RegexpResponder

  regexp: /you're the best|your the best/

  randomResponse: ->
    sound: 'danielsan'


module.exports = new Responder()
