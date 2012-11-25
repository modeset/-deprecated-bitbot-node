# Adapted from a project by Nick Gauthier
# https://github.com/ngauthier/hubot-github-heroku-deploy

ChildProcess = require('child_process')

class HerokuDeployer

  constructor: (@room, @repo_url, @app_name, @branch) ->

  run: =>
    heroku_url = "git@heroku.com:#{@app_name}.git"
    @room.speak "Deploying #{@branch} from #{@repo_url} to #{heroku_url}"
    deploy = ChildProcess.spawn('bin/git-deploy.sh', [ @repo_url, heroku_url, @branch ])
    deploy.stdout.on 'data', @processDidOutput
    deploy.stderr.on 'data', @processDidOutput
    deploy.on 'exit', @processDidExit

  processDidOutput: (data) =>
    @room.speak(m) for m in data.toString().split("\n") when m.length > 0

  processDidExit: (code) =>
    @room.speak 'Deploy complete!'


exports.helpMessage = """
                      Deploy an app to Heroku when you say 'deploy go'
                        Note that you must first configure a repo, Heroku app and branch with the following:
                          deploy set-heroku-app <appname>
                          deploy set-git-repo <repo>
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
      console.log 'Prechecking deployment'
      console.log config
      unless config['heroku-app'] and config['git-repo'] and config['branch']
        room.speak 'I don\'t have all the info I need to deploy from this room. Have you set an app, a repo, and a branch?'
      else
        (new HerokuDeployer(room, config['git-repo'], config['heroku-app'], config['branch'])).run()

  if command is 'set-heroku-app'
    bot.redis.hset redis_key, 'heroku-app', value, (err, reply) ->
      room.speak "Heroku app for deployment has been set to #{value}"

  if command is 'set-git-repo'
    bot.redis.hset redis_key, 'git-repo', value, (err, reply) ->
      room.speak "Git repo for deployment has been set to #{value}"

  if command is 'set-branch'
    bot.redis.hset redis_key, 'branch', value, (err, reply) ->
      room.speak "Git branch for deployment has been set to #{value}"

