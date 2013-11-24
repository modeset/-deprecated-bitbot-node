class Responder extends Bitbot.RegexpResponder

  regexp: /(?:\b)(fuck yeah|shit yeah)(?:\b)/


  randomResponse: ->
    sound: 'yeah'



module.exports = new Responder()
