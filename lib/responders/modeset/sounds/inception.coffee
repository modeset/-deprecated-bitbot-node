class Responder extends Bitbot.RegexpResponder

  regexp: /(?:\b)(inception|dream|deeper)(?:\b)/

  randomResponse: ->
    sound: 'deeper'


module.exports = new Responder()
