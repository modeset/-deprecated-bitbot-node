class SimpleResponder

  @messageRegex = null
  @responses = []

  constructor: (@messageRegex, @responses) ->

  hear: (message, room, bot) ->
    random = @responses[Math.floor(Math.random() * @responses.length)]
    room.speak random if message.userId != bot.botUserId and message.body and message.body.match(@messageRegex)

module.exports = SimpleResponder
