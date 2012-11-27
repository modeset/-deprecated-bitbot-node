_ = require 'underscore'

exports.helpMessage = "Repeat your last action when you say '!!'"

exports.receiveMessage = (message, room, bot) ->
  redis_key = "lastcommands-#{room.id}"
  if message.body is '!!'
    bot.redis.hget redis_key, message.userId, (err, reply) ->
      if reply
        bot.respondToMessage room, JSON.parse(reply)
      else
        room.speak 'Sorry, I don\'t have a previous command from you to repeat'
  else
    strippedMessage = _(message).pick('id', 'body', 'type', 'roomId', 'userId', 'tweet', 'createdAt')
    bot.redis.hset redis_key, message.userId, JSON.stringify(strippedMessage), (err, reply) ->
