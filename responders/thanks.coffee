SimpleResponder = require './simple_responder'

responses = [ 'NP',
              'any time!',
              'you got it',
              'you\'re welcome' ]

regex     = /thank/
thanks    = new SimpleResponder(regex, responses)

module.exports = thanks
 