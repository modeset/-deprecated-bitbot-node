class HerokuMigrator

  constructor: (@room, @repo_url, @app_name) ->
    @transcript = []

  run: =>
    @room.speak "Okay, I'm migrating #{@app_name}. Hold on to your hat."
    heroku_url = "git@heroku.com:#{@app_name}.git"
    deploy = ChildProcess.spawn('bin/git-deploy.sh', [ @repo_url, heroku_url, @branch ])
    deploy.stdout.on 'data', @processDidOutput
    deploy.stderr.on 'data', @processDidOutput
    deploy.on 'exit', @processDidExit

  processDidOutput: (data) =>
    @transcript.push(m) for m in data.toString().split("\n") when m.length > 0

  processDidExit: (code) =>
    @room.paste @transcript.join("\n")
    if code is 0
      @room.speak "Alright, #{@app_name} is deployed!"
    else
      @room.speak "Uh oh, something went wrong deploying #{@app_name}. You might want to check the logs and retry."



exports.helpMessage = """
                      Run a command on a Heroku app when you say 'run <command> on <name> please'
                      """

exports.receiveMessage = (message, room, bot) ->

  # Abort if this is a presence message
  return unless message?.body

  # Abort if this is a bot message
  return if message.userId is bot.botUserId

  redis_key = "apps-config-#{room.id}"
  app_name  = null
  branch    = 'master'

  if match = message.body.match(/deploy (\S+)$/)
    room.speak 'Nuh-uh. Ask nicely.'
    return

  if match = message.body.match(/deploy (\S+) from (\S+)$/)
    room.speak 'Nuh-uh. Ask nicely.'
    return

  if match = message.body.match(/deploy (\S+) please$/)
    app_name = match[1]

  if match = message.body.match(/deploy (\S+) from (\S+) please$/)
    app_name  = match[1]
    branch    = match[2]

  return unless app_name

  # Let's do it
  bot.redis.hget redis_key, app_name, (err, key) ->
    unless key
      room.speak "Sorry, I don't think that app is set up for this room"
    else
      bot.redis.hgetall key, (err, config) ->
        unless config and config['heroku_app'] and config['git_repo']
          room.speak "Sorry, I don't have all the info I need to deploy from this room. Have you set an app, a repo, and a branch?"
        else
          setTimeout (new HerokuDeployer(room, config['git_repo'], config['heroku_app'], branch)).run, 250
