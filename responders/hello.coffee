SimpleResponder = require '../src/simple_responder'

responses       = ['http://i1.kym-cdn.com/photos/images/newsfeed/000/217/040/48ACD.png']
regex           = /hello/
module.exports  = new SimpleResponder(regex, responses)
