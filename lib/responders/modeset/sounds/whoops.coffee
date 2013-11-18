class Responder extends Bitbot.RegexpResponder

  regexp: /oops/

  randomResponse: ->
    sound: 'trombone'


module.exports = new Responder()
