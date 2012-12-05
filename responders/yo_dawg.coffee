SimpleResponder = require '../src/simple_responder'

responses       = ['yo dawg', '0110100001101001', 'well hello there']
regex           = /hello bit(\s?)bot|yo dawg|sup bit(\s?)bot|morning bit(\s?)bot/
module.exports  = new SimpleResponder(regex, responses)
