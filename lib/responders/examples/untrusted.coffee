count = 0

exports.main = (message = m, callback = exit) ->
  callback(speak: "Local untrusted responder overheard `#{message.body}` in #{message.roomName} (#{count += 1} messages so far).")
