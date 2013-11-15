_ = require 'underscore'

class AppRegistry

  constructor: (@redis, @room) ->
    @redis_key = "apps-config-#{room.id}"

  add: (name, git_repo, heroku_app, callback) =>
    app_redis_key = "#{@redis_key}-#{name}"
    @redis.hset @redis_key, name, app_redis_key, (err, reply) =>
      app_config =
        'git_repo':   git_repo
        'heroku_app': heroku_app
      @redis.hmset app_redis_key, app_config, (err, reply) =>
        callback.call @

  remove: (app_name, win, fail) =>
    @redis.hget @redis_key, app_name, (err, key) ->
      unless key
        @fail.call @
      else
        @redis.hdel redis_key, app_name, (err, reply) ->
          @redis.del key, (err, reply) ->
            @win.call @

  count: (callback) =>
    @redis.hgetall @redis_key, (err, apps) ->
      callback.call @, _(apps).size()

  fetch: (name, callback) =>
    @redis.hgetall @redis_key, (err, apps) =>
      @redis.hgetall apps[name], (err, config) =>
        callback.call @, config

  each: (callback) =>
    @redis.hgetall @redis_key, (err, apps) =>
      if apps
        for name, key of apps
          do (name, key) =>
            @redis.hgetall key, (err, config) =>
              config['name'] = name if config
              callback.call @, config

module.exports = AppRegistry
