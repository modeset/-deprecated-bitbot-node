count = 0

exports.main = (message = m, callback = exit) ->
  callback(speak: "Local trusted command processor handled `#{message.body}` in #{message.roomName} (#{count += 1} messages so far).")
