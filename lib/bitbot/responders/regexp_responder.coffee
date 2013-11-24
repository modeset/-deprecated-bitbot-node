BaseResponder = require './base_responder'

class RegexpResponder extends BaseResponder

  regexp: null
  responses: []


  respondsTo: (message) ->
    @regexp.test(message.body)


  respond: (@message, callback) ->
    return unless @regexp.test(@message.body)
    @randomResponse(callback)


  randomResponse: (callback) ->
    callback(speak: @responses[Math.floor(Math.random() * @responses.length)])



module.exports = RegexpResponder
