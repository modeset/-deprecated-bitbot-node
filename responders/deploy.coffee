# Adapted from a project by Nick Gauthier
# https://github.com/ngauthier/hubot-github-heroku-deploy

ChildProcess = require('child_process')

class HerokuDeployer

  constructor: (@room, @repo_url, @app_name, @branch) ->

  deploy: =>
    heroku_url = "git@heroku.com:#{@app_name}.git"
    @room.speak "Deploying #{@branch} from #{@repo_url} to #{heroku_url}"
    deploy = ChildProcess.spawn('bin/git-deploy.sh', [ @repo_url, heroku_url, @branch ])
    deploy.stdout.on 'data', @processDidOutput
    deploy.stderr.on 'data', @processDidOutput
    deploy.stderr.on 'exit', @processDidExit

  processDidOutput: (data) =>
    @room.speak(m) for m in data.toString().split("\n") when m.length > 0

  processDidExit: =>
    @room.speak 'Deploy complete!'


exports.helpMessage = "Deploy an app to Heroku when you say 'deploy go'"

exports.receiveMessage = (message, room, bot) ->

  # See if we're relevant and get the command
  match = message.body.match(/^deploy (\S+)(?: (\S+))?$/)
  return unless match
  command = match[1]
  value = match[2]

  # Configure ourselves
  redis_key = "deploy-config-#{room.id}"

  if command is 'go'
    config = bot.redis.hgetall(redis_key)
    unless config['heroku-app'] and config['git-repo'] and config['branch']
      room.speak 'I don\'t have all the info I need to deploy from this room. Have you set an app, a repo, and a branch?'
    else
      new HerokuDeployer(room, config['git-repo'], config['heroku-app'], config['branch'])

  if command is 'set-heroku-app'
    bot.redis.hset redis_key, 'heroku-app', value, (err, reply) ->
      room.speak "Heroku app for deployment has been set to #{value}"

  if command is 'set-git-repo'
    bot.redis.hset redis_key, 'git-repo', value, (err, reply) ->
      room.speak "Git repo for deployment has been set to #{value}"

  if command is 'set-branch'
    bot.redis.hset redis_key, 'branch', value, (err, reply) ->
      room.speak "Git branch for deployment has been set to #{value}"

