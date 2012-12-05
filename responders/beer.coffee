SimpleResponder = require '../src/simple_responder'

responses       = ['http://i296.photobucket.com/albums/mm185/robslink1/homer_beer_2401_d.jpg']
regex           = /beer/
module.exports  = new SimpleResponder(regex, responses)
