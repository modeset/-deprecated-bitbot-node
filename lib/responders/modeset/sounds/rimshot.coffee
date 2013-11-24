class Responder extends Bitbot.RegexpResponder

  regexp: /(?:\b)(rimshot)(?:\b)/


  randomResponse: ->
    sound: 'rimshot'



module.exports = new Responder()
