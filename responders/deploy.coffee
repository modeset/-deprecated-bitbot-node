# Adapted from a Hubot plugin by Nick Gauthier
# https://github.com/ngauthier/hubot-github-heroku-deploy

ChildProcess = require('child_process')

class HerokuDeployer

  constructor: (@room, @repo_url, @app_name, @branch) ->

  run: =>
    @room.speak "Okay, I'm deploying #{@branch} from #{@repo_url} to #{@app_name}. Here we go!"
    heroku_url = "git@heroku.com:#{@app_name}.git"
    deploy = ChildProcess.spawn('bin/git-deploy.sh', [ @repo_url, heroku_url, @branch ])
    deploy.stdout.on 'data', @processDidOutput
    deploy.stderr.on 'data', @processDidOutput
    deploy.on 'exit', @processDidExit

  processDidOutput: (data) =>
    @room.paste(m) for m in data.toString().split("\n") when m.length > 0

  processDidExit: (code) =>
    @room.speak "Hey, I'm all finished deploying #{@app_name}! You should probably check it out now."


exports.helpMessage = """
                      Deploy an app to Heroku when you say 'deploy go'
                        Note that you must first configure a repo, Heroku app and branch with the following:
                          deploy set-app <appname>
                          deploy set-repo <repo>
                          deploy set-branch <branch>
                      """

exports.receiveMessage = (message, room, bot) ->

  return unless message?.body

  # See if we're relevant and get the command
  match = message.body.match(/^deploy (\S+)(?: (\S+))?$/)
  return unless match
  command = match[1]
  value = match[2]

  # Configure ourselves
  redis_key = "deploy-config-#{room.id}"

  if command is 'go'
    bot.redis.hgetall redis_key, (err, reply) ->
      config = reply
      room.speak 'One moment, checking deployment settings'
      unless config and config['heroku-app'] and config['git-repo'] and config['branch']
        room.speak 'Sorry, I don\'t have all the info I need to deploy from this room. Have you set an app, a repo, and a branch?'
      else
        (new HerokuDeployer(room, config['git-repo'], config['heroku-app'], config['branch'])).run()

  if command is 'set-app'
    bot.redis.hset redis_key, 'heroku-app', value, (err, reply) ->
      room.speak "Got it, the Heroku app for deployment will be #{value}"

  if command is 'set-repo'
    bot.redis.hset redis_key, 'git-repo', value, (err, reply) ->
      room.speak "Got it, the Git repo for deployment will be #{value}"

  if command is 'set-branch'
    bot.redis.hset redis_key, 'branch', value, (err, reply) ->
      room.speak "Got it, the Git branch for deployment will be #{value}"

