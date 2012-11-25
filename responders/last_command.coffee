_ = require 'underscore'

exports.helpMessage = "repeat your last action when you say '!!'"

exports.receiveMessage = (message, room, bot) ->
  if message.body is '!!'
    bot.redis.hget 'lastcommands', message.userId, (err, reply) ->
      if reply
        bot.respondToMessage room, JSON.parse(reply)
      else
        room.speak 'Sorry, I don\'t have a previous command from you to repeat'
  else
    strippedMessage = _(message).pick('id', 'body', 'type', 'roomId', 'userId', 'tweet', 'createdAt')
    bot.redis.hset 'lastcommands', message.userId, JSON.stringify(strippedMessage), (err, reply) ->
