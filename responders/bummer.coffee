SimpleResponder = require '../src/simple_responder'

responses       = [ 'http://static.happyplace.com/assets/images/2011/10/4eaec154866a8.jpg' ]
regex           = /bummer/
module.exports  = new SimpleResponder(regex, responses)
