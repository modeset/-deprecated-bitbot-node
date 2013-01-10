# Adapted from a Hubot plugin by Nick Gauthier
# https://github.com/ngauthier/hubot-github-heroku-deploy

ChildProcess = require 'child_process' 
Shred = require 'shred' 

class HerokuApp

  constructor: (@room, @redis, @app_name) ->
    @http_client = new Shred()
    @redis_key = "apps-config-#{room.id}"

  getAppConfig: (callback) =>
    @redis.hget @redis_key, @app_name, (err, key) ->
      unless key
        room.speak "Sorry, I don't think that app is set up for this room"
      else
        @app_redis_key = key
        bot.redis.hgetall key, (err, config) ->
          @app_config = config
          @callback.call @, config

  migrate: =>
    @http_client.post
      url: "https://api.heroku.com/apps/#{@app_config['heroku_app']}/ps"
      content: 
        command: 'rake db:migrate'
        attach: true

  run: =>
    @room.speak "Okay, I'm deploying #{@branch} from #{@repo_url} to #{@app_name}. Here we go..."
    heroku_url = "git@heroku.com:#{@app_name}.git"
    deploy = ChildProcess.spawn('bin/git-deploy.sh', [ @repo_url, heroku_url, @branch ])
    unless @quiet
      deploy.stdout.on 'data', @processDidOutput
      deploy.stderron 'data', @processDidOutput
    deploy.on 'exit', @processDidExit

  processDidOutput: (data) =>
    @room.speak(m) for m in data.toString().split("\n") when m.length > 0

  processDidExit: (code) =>
    # The outut buffer sometimes lags just slightly, so introduce a delay to make sure it's flushed
    setTimeout @printDoneMessage, 250

  printDoneMessage: (code) =>
    if code is 0
      @room.speak "Alright, I'm done deploying #{@app_name}! You should probably check it out now."
    else
      @room.speak "Something went wrong deploying #{@app_name}. You should probably check the logs and retry."


exports.helpMessage = """
                      Deploy an app to Heroku when you say 'deploy <name> please'
                        By default that will deploy from master, but you can change the branch with 'deploy <name> from <branch> please'
                      """

exports.receiveMessage = (message, room, bot) ->

  # Abort if this is a presence message
  return unless message?.body

  # Abort if this is a bot message
  return if message.userId is bot.botUserId

  app_name  = null

  if match = message.body.match(/migrate (\S+)$/)
    room.speak 'Nuh-uh. Ask nicely.'
    return

  if match = message.body.match(/migrate (\S+) please$/)
    app_name = match[1]

  return unless app_name

  # Let's do it
  heroku = new HerokuApp(room, bot.redis, app_name)
      bot.redis.hgetall key, (err, config) ->
        unless config and config['heroku_app'] and config['git_repo']
          room.speak "Sorry, I don't have all the info I need to deploy from this room. Have you set an app, a repo, and a branch?"
        else
          setTimeout (new HerokuDeployer(room, config['git_repo'], config['heroku_app'], branch, quiet)).run, 250
