exports.helpMessage = "repeat your last action when you say '!!'"

exports.receiveMessage = (message, room, bot) ->
  if message.body is '!!'
    bot.redis.hget 'lastcommands', message.userId, (err, reply) ->
      if reply
        bot.respondToMessage room, JSON.parse(reply)
      else
        console.log 'No last message found to reply to'
  else
    bot.redis.hset 'lastcommands', message.userId, JSON.stringify(message), (err, reply) ->
