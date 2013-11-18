class Responder extends Bitbot.RegexpResponder

  regexp: /inception|dream|deeper/

  randomResponse: ->
    sound: 'deeper'


module.exports = new Responder()
