class Responder extends Bitbot.BaseResponder

  responderName: "Heroku Deployment"
  responderDesc: "Provides commands to configure and deploy applications to heroku (room specific)."

  commandPrefix: "heroku:app"

  commands:
    add:
      desc: "Add a heroku application"
      examples: ["add an application please.", "create an application named spring.", "setup a new application."]
      intent: "herokuapp:add"
      opts:
        name: {type: "string", entity: "client"}
        app: {type: "string"}
        repo: {type: "string"}

    update:
      desc: "Update an existing heroku application"
      examples: ["update the spring app to use spring-production.", "change the spring application to git@github.com:modeset/spring.git"]
      intent: "herokuapp:configure"
      opts:
        name: {type: "string", entity: "client"}
        value: {type: "string", note: "parsed to determine the type of value"}

    list:
      desc: "List heroku applications"
      examples: ["what applications are there?", "list applications."]
      intent: "herokuapp:list"

    remove:
      desc: "Remove a heroku application from the list"
      examples: ["remove the spring application.", "delete the spring app."]
      intent: "herokuapp:remove"
      opts:
        name: {type: "string", entity: "client"}

    deploy:
      desc: "Deploys a heroku application"
      examples: ["deploy the spring application please.", "please deploy the spring application from master."]
      intent: "herokuapp:deploy"
      opts:
        name: {type: "string", entity: "client"}
        branch: {type: "string", default: "master"}

  templates:
    missingToken: "Sorry {{&initials}}, I didn't the application you're talking about. Try phrasing it differently?"
    missingValue: "Sorry {{&initials}}, I didn't get what you wanted to change. Try phrasing it differently?"
    createToken: "Setting up a new application?\n❓ Okay {{&initials}}, what do you want to name it?"
    createApp: "Okay {{&name}}, I've added an application named \"{{&token}}\".\n❓ To get setup, what's the application name on heroku? (eg. bitbot-production)"
    createRepo: "Awesome, almost done {{&initials}}.\n❓ To finalize this, what's the git repo? (eg. git@github.com:modeset/bitbot.git)"
    create: "Okay {{&initials}}, thanks. I've setup the {{&token}} app for you."
    update: "Okay {{&name}}, I updated {{&token}}'s {{&key}} to {{&value}}."
    removeConfirm: "Whoa {{&name}}, but this will remove the {{&token}} application!\n❓ Are you sure?"
    notRemoved: "Okay {{&name}}, I didn't remove it."
    removed: "Okay {{&name}}, I removed the {{&token}} application."
    sayPlease: "Sorry {{&name}}, not until you ask nicely and say please."
    appNotFound: "Sorry {{&name}}, I don't think that application has been configured for this room."
    appNotConfigured: "Sorry {{&name}}, I don't have all the info needed to deploy that app. Make sure you've configured it fully."
    deploying: "Okay {{&name}}, I'm deploying {{&branch}} from {{&repo}} to {{&app}}. Hold on to your hat."
    deploySuccessful: "Okay {{&name}}, {{&app}} deployed successfully. Here are the logs for you to review."
    deployUnsuccessful: "Sorry {{&name}}, something went wrong deploying {{&app}}. Here are the logs for you to review."
    list: """
      🚇 Heroku Applications

      {{#message}}{{&.}}{{/message}}{{#applications}}{{&token}} heroku: {{&app}} / repo: {{&repo}}\n{{/applications}}
      """


  add: (token, app, repo) ->
    if repo
      new Registry(@message.room.id).upsert(token, {app: app, repo: repo})
      speak: @t('create', token: token)
    else if app
      speak: @t('createRepo', token: token)
      prompt: (message) => @add(token, app, message.body)
    else if token
      speak: @t('createApp', token: token)
      prompt: (message) => @add(token, message.body, null)
    else
      speak: @t('createToken')
      prompt: (message) => @add(message.body, null, null)


  update: (token, value, callback) ->
    unless token then return speak: @t('missingToken')
    unless value then return speak: @t('missingValue')

    record = if "#{value}".match(/^git@/) then {repo: value} else {app: value}

    registry = new Registry(@message.room.id)
    registry.upsert(token, record)
    speak: @t('update', token: token, key: (if record.repo then 'repo' else 'heroku app'), value: value)


  list: (callback) ->
    registry = new Registry(@message.room.id)
    registry.all true, (records) =>
      message = "Looks like there aren't any applications configured!" unless records
      applications = []
      for record in records || []
        applications.push
          token: @padRight(record._token || 'unknown', 20)
          app: record.app
          repo: record.repo
      callback(paste: @t('list', message: message, applications: applications))


  remove: (token) ->
    unless token then return speak: @t('missingToken')

    speak: @t('removeConfirm', token: token)
    confirm: (confirmed) =>
      unless confirmed then return speak: @t('notRemoved')
      registry = new Registry(@message.room.id)
      registry.remove(token)
      speak: @t('removed', token: token)


  deploy: (token, branch, callback) ->
    unless token then return speak: @t('missingToken')
    unless @message.body.match(/(?:\b)please(?:\b)/gi) then return speak: @t('sayPlease')

    registry = new Registry(@message.room.id)
    registry.fetch token, (app) =>
      unless app then return callback(speak: @t('appNotFound'))
      unless app.app && app.repo then return callback(speak: @t('appNotConfigured'))

      callback(speak: @t('deploying', branch: branch, app: app.app, repo: app.repo))
      new DeployerOfWorlds(app, branch).deploy (success, transcript) =>
        message = if success then @t('deploySuccessful', app: app.app) else @t('deployUnsuccessful')
        callback(speak: message, paste: transcript)



class Registry extends Bitbot.BaseResponder.Registry
  constructor: (roomId) -> super("apps-config-#{roomId}")



class DeployerOfWorlds

  constructor: (@app, @branch) ->
    @transcript = []


  deploy: (@callback) ->
    deploy = ChildProcess.spawn('lib/responders/bin/git-deploy.sh', [@app.repo, "git@heroku.com:#{@app.app}.git", @branch])
    deploy.stdout.on('data', @processDidOutput)
    deploy.stderr.on('data', @processDidOutput)
    deploy.on('exit', @processDidExit)


  processDidOutput: (data) =>
    @transcript.push(m) for m in data.toString().split("\n") when m.length > 0


  processDidExit: (code) =>
    @callback(code is 0, @transcript.join('\n'))



module.exports = new Responder()
