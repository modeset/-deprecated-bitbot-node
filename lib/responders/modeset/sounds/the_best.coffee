class Responder extends Bitbot.RegexpResponder

  regexp: /(?:\b)(you're the best|your the best)(?:\b)/

  randomResponse: ->
    sound: 'danielsan'


module.exports = new Responder()
