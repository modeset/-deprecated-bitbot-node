exports.helpMessage = "Be silent unless spoken directly to when told to shut up"

exports.respond = (message, room, bot) ->
  if /shut up|earmuffs/.test( message.body )
    room.speak 'Sorry. I\'ll be quiet for the next 5 minutes unless you speak directly to me.'
    bot.earmuffs(room)
