class Responder extends Bitbot.RegexpResponder

  regexp: /(?:\b)(oops|woops|whoops)(?:\b)/


  randomResponse: ->
    sound: 'trombone'



module.exports = new Responder()
