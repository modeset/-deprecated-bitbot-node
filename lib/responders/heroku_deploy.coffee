ChildProcess = require('child_process')
request = require('request')

class Responder extends Bitbot.BaseResponder

  responderName: "Heroku Deployment"
  responderDesc: "Provides commands to configure and deploy applications to heroku (room specific)."

  commandPrefix: "heroku:app"

  commands:
    add:
      desc: "Add a heroku application"
      examples: ["Add an application please.", "Create an application named spring.", "Setup a new application."]
      intent: "herokuapp:add"
      opts:
        name: {type: "string", entity: "client"}
        app: {type: "string"}
        repo: {type: "string"}

    configure:
      desc: "Configure an existing heroku application"
      examples: ["Set the spring app to use spring-production.", "Change the spring application to git@github.com:modeset/spring.git"]
      intent: "herokuapp:configure"
      opts:
        name: {type: "string", entity: "client"}
        value: {type: "string", note: "(parsed to determine the type of value)"}

    list:
      desc: "List heroku applications"
      examples: ["What applications are there?", "List applications."]
      intent: "herokuapp:list"

    remove:
      desc: "Remove a heroku application from the list"
      examples: ["Remove the foo application.", "Delete the foo app."]
      intent: "herokuapp:remove"
      opts:
        name: {type: "string", entity: "client"}

    deploy:
      desc: "Deploys a heroku application"
      examples: ["Deploy the foo application.", "Deploy the foo application from master."]
      intent: "herokuapp:deploy"
      opts:
        name: {type: "string", entity: "client"}
        branch: {type: "string", default: "master"}


  add: (name, app, repo, callback) ->
    if repo
      registry = new Registry(@message.room.id)
      registry.upsert name, app, repo, =>
        console.log('testing', @message.user.name, name, app, repo, callback)
        callback(speak: "🚇 Okay #{@message.user.name}, thanks. I've setup the #{name} app for you.")
    else if app
      speak: "🚇 Awesome, almost done #{@message.user.initials}.\n❓ To finalize this, what's the git repo? (eg. git@github.com:modeset/bitbot.git)"
      prompt: (message) => @add(name, app, message.body, callback)
    else if name
      speak: "🚇 Okay #{@message.user.name}, I added an application named \"#{name}\".\n❓ To get setup, what's the application name on heroku? (eg. bitbot-production)"
      prompt: (message) => @add(name, message.body, null, callback)
    else
      speak: "🚇 Setting up a new application?\n❓ Okay #{@message.user.initials}, what do you want to name it?"
      prompt: (message) => @add(message.body, null, null, callback)


  configure: (name, value, callback) ->
    return {speak: "Sorry #{@message.user.initials}, I didn't get what application you wanted to change. Try phrasing it differently?"} unless name
    return {speak: "Sorry #{@message.user.initials}, I didn't get what you wanted to change. Try phrasing it differently?"} unless value

    userName = @message.user.name
    if "#{value}".match(/^git@/)
      app = null
      repo = value
    else
      app = value
      repo = null

    registry = new Registry(@message.room.id)
    registry.fetch name, (config) ->
      registry.upsert name, app || config['heroku_app'], repo || config['git_repo'], ->
        callback(speak: "🚇 Okay #{userName}, I updated #{name}'s #{if repo then 'repo' else 'app'} to #{value}.")


  list: (callback) ->
    registry = new Registry(@message.room.id)
    registry.all (apps) =>
      response = "🚇 Configured Applications\n\n"
      if apps.length
        response += "#{@message.user.name}, here's a list of configured applications.\n"
      else
        response += "#{@message.user.name}, looks like there aren't any applications configured."
      for app in apps
        response += "\n☛️ #{app['name'] + Array(20 - app['name'].length + 1).join(" ")}"
        response += " app: #{app['heroku_app']} / repo: #{app['git_repo']}"
      callback(paste: response)


  remove: (name, callback) ->
    return {speak: "Sorry #{@message.user.initials}, I didn't get what you wanted to remove. Try phrasing it differently?"} unless name

    speak: "🚇 Whoa #{@message.user.name}, but this will remove the #{name} application! Are you sure?"
    confirm: (confirmed) =>
      return {speak: "🚇 Okay, I didn't remove it."} unless confirmed
      registry = new Registry(@message.room.id)
      registry.remove name, (err) =>
        return callback(speak: "Sorry #{@message.user.initials}, I wasn't able to remove that application. :(") if err
        callback(speak: "🚇 Okay #{@message.user.name}, I removed #{name}.")


  deploy: (name, branch, callback) ->
    return {speak: "Sorry #{@message.user.initials}, I didn't get what you wanted to deploy. Try phrasing it differently?"} unless name
    return {speak: "#{@message.user.name}, no, not until you ask nicely."} unless @message.body.match(/(?:\b)please(?:\b)/gi)

    registry = new Registry(@message.room.id)
    registry.fetch name, (config) =>
      callback(speak: "Sorry #{@message.user.name}, I don't think that app is set up for this room.") unless config
      callback(speak: "Sorry #{@message.user.name}, I don't have all the info I need to deploy from this room. Make sure you've configured the app.") unless config['heroku_app'] && config['git_repo']
      @delay(250, => new DeployerOfWorlds(config['heroku_app'], config['git_repo'], branch, @message.user.name, callback))


  delay: (time, callback) ->
    setTimeout(callback, time)



class Registry

  constructor: (@roomId) ->
    @key = "apps-config-#{@roomId}"


  upsert: (name, app, repo, callback) ->
    key = "#{@key}-#{name}"
    redis.hset @key, name, key, (err, reply) ->
      config = {git_repo: repo, heroku_app: app}
      redis.hmset(key, config, (err, reply) -> callback())


  remove: (name, callback) ->
    redis.hget @key, name, (err, key) ->
      callback(new Error('Unable to find key')) unless key
      redis.hdel key, name, (err, reply) ->
        redis.del(key, (err, reply) -> callback())


  fetch: (name, callback) ->
    redis.hgetall @key, (err, apps) ->
      redis.hgetall apps[name], (err, config) ->
        callback(config) unless err


  all: (callback) ->
    redis.hgetall @key, (err, apps = {}) ->
      arr = []
      count = Object.keys(apps).length
      return callback(arr) if count == 0 || err

      for name, key of apps
        do(name, key) ->
          redis.hgetall key, (err, config) ->
            count -= 1
            if config
              config['name'] = name
              arr.push(config)
            callback(arr) if count == 0


class DeployerOfWorlds

  constructor: (@app, @repo, @branch, @userName, @callback) ->
    @transcript = []
    @callback(speak: "Okay #{@userName}, I'm deploying #{@branch} from #{@repo} to #{@app}. Hold on to your hat.")
    deploy = ChildProcess.spawn('lib/responders/bin/git-deploy.sh', [@repo, "git@heroku.com:#{@app}.git", @branch])
    deploy.stdout.on('data', @processDidOutput)
    deploy.stderr.on('data', @processDidOutput)
    deploy.on('exit', @processDidExit)


  processDidOutput: (data) =>
    @transcript.push(m) for m in data.toString().split("\n") when m.length > 0


  processDidExit: (code) =>
    message = "Okay #{@userName}, #{@app} deployed successfully. Pasting the logs here for you to review."
    message = "Sorry #{@userName}, something went wrong deploying #{@app}. Pasting the logs here for you to review." if code != 0
    @callback(speak: message, paste: @transcript.join("\n"))


module.exports = new Responder()
