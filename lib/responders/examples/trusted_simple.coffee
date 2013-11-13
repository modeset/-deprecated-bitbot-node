responder = new Bitbot.SimpleResponder(/bot/, ["I'm a local trusted simple responder, what can I help you with?"])

exports.main = (message = m, callback = exit) ->
  responder.main(message, callback)
