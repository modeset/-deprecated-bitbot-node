class SimpleResponder

  constructor: (@regexp = null, @responses = []) ->


  main: (message, callback) =>
    return unless message.body.match(@regexp)
    callback(speak: @randomResponse())


  randomResponse: ->
    @responses[Math.floor(Math.random() * @responses.length)]


module.exports = SimpleResponder
