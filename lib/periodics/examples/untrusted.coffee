count = 0

exports.main = (callback = exit) ->
  callback(paste: "Local untrusted periodic (notified #{count + 1} #{if (count += 1) == 1 then 'time' else 'times'})")
