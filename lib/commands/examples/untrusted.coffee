count = 0

exports.main = (message = m, callback = exit) ->
#  callback(speak: "Local untrusted command processor handled `#{message.body}` in #{message.roomName} (#{count += 1} messages so far).")
  callback(speak: "Wit said: #{message.wit.intent} -- with #{message.wit.confidence} confidence")
