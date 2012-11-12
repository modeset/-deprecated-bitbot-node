SimpleResponder = require './simple_responder'

responses       = [ 'http://i1.kym-cdn.com/photos/images/original/000/103/256/i-fucking-love-cocaine.jpg' ]
regex           = /love/
module.exports  = new SimpleResponder(regex, responses)
