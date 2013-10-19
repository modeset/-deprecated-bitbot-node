SimpleResponder = require '../simple_responder'

responses = [ 'NP',
              'any time!',
              'you got it',
              'you\'re welcome',
              'no, thank you!',
              'you\'re nice',
              '*high five*' ]

regex           = /thank/
module.exports  = new SimpleResponder(regex, responses)
