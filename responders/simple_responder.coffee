class SimpleResponder

  constructor: (@inputFilter, @responses) ->
  
  @inputFilter = null
  @responses = []
  
  receiveMessage: (message, room, client) ->
    random = @responses[Math.floor(Math.random() * @responses.length)]
    room.speak random if message.userId != client.bitBotId and message.body and message.body.match(@inputFilter)

module.exports = SimpleResponder