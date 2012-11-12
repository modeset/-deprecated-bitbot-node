SimpleResponder = require './simple_responder'

responses       = ['TWSS']
regex = /(?:\b)(big one|in yet|fit that in|long enough|take long|hard|rough|large|stab at it)(?:\b)/
module.exports  = new SimpleResponder(regex, responses)
