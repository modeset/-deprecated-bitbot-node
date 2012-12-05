SimpleResponder = require '../src/simple_responder'

responses = [ 'NP',
              'any time!',
              'you got it',
              'you\'re welcome' ]

regex           = /thank/
module.exports  = new SimpleResponder(regex, responses)
