class Responder extends Bitbot.RegexpResponder

  regexp: /fuck yeah|shit yeah/

  randomResponse: ->
    sound: 'yeah'


module.exports = new Responder()
