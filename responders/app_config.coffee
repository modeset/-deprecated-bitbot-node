_ = require('underscore')

exports.helpMessage = """
                      Configure an app for management via this room:
                        Add (or update) it when you say 'add an app <name> <heroku app> <repo>'
                        List all apps when you say 'what apps are there?'
                        Remove one when you say 'remove the app <name>'
                      """

exports.receiveMessage = (message, room, bot) ->

  redis_key = "apps-config-#{room.id}"

  return unless message?.body

  # Add an app
  if match = message.body.match(/add(?: an) app (\S+) (\S+) (\S+)$/)

    name        = match[1]
    heroku_app  = match[2]
    repo        = match[3]

    app_redis_key = "#{redis_key}-#{name}"
    bot.redis.hset redis_key, name, app_redis_key, (err, reply) ->
      app_config =
        'git_repo':   repo
        'heroku_app': heroku_app
      bot.redis.hmset app_redis_key, app_config, (err, reply) ->
        room.speak "Got it, I've added '#{name}' to the list of apps for this room"

  # List apps
  if match = message.body.match(/what apps are there(?:\?)?$/)
    bot.redis.hgetall redis_key, (err, apps) ->
      if _(apps).size() > 0
        room.speak "Here's the list of apps I know about:"
        for name, key of apps
          do (name, key) ->
            bot.redis.hgetall key, (err, config) ->
              if config and config['git_repo'] and config['heroku_app']
                room.speak "'#{name}' from '#{config['git_repo']}', pointed to '#{config['heroku_app']}' on Heroku"
      else
        room.speak "I don't know any apps"


  # Delete an app
  if match = message.body.match(/remove(?: the)? app (\S+)$/)
    app_name = match[1]
    bot.redis.hget redis_key, app_name, (err, key) ->
      unless key
        room.speak "Sorry, I don't think that app is set up for this room"
      else
        bot.redis.hdel redis_key, app_name, (err, reply) ->
          bot.redis.del key, (err, reply) ->
            room.speak "Okay, '#{app_name}' is removed from this room"
