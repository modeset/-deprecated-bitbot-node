SimpleResponder = require './simple_responder'

responses = ["http://cdn.memegenerator.net/instances/400x/24281542.jpg"]
regex = /db/
query = new SimpleResponder(regex, responses)

module.exports = query
