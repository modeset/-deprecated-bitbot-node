SimpleResponder = require './simple_responder'

responses = ['http://i1.kym-cdn.com/photos/images/newsfeed/000/217/040/48ACD.png']
regex     = /hello/
helloResponder    = new SimpleResponder(regex, responses)

module.exports = helloResponder
