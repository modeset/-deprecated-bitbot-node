SimpleResponder = require './simple_responder'

responses = ['http://i296.photobucket.com/albums/mm185/robslink1/homer_beer_2401_d.jpg']
regex     = /beer/
beer    = new SimpleResponder(regex, responses)

module.exports = beer