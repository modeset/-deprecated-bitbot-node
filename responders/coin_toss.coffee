SimpleResponder = require '../src/simple_responder'

responses       = ['Heads', 'Tails']
regex           = /flip a coin/
module.exports  = new SimpleResponder(regex, responses)
