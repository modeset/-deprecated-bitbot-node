#class

#Bitbot.registerResponder
#  name: 'Foo'
#  version: '1.0.0'
#  description: 'foo'
#  usage: 'foo'
#  endpoint: (message, callback) -> console.log(message, callback)


#module.exports =





















_ = require('underscore')
AppRegistry = require '../app_registry'

class AppRegistryResponder

  helpMessage: """
                  Configure an app for management via this room:
                    Add (or update) it when you say 'add an app <name> <heroku app> <repo>'
                    List all apps when you say 'what apps are there?'
                    Remove one when you say 'remove the app <name>'
               """

  respond: (message, room, bot) =>
    registry = new AppRegistry(bot.redis, room)


    # Add an app
    if match = message.body.match(/add(?: an) app (\S+) (\S+) (\S+)$/)

      name        = match[1]
      heroku_app  = match[2]
      repo        = match[3]

      registry.add name, repo, heroku_app, =>
        room.speak "Got it, I've added '#{name}' to the list of apps for this room"

    # List apps
    if match = message.body.match(/what apps are there(?:\?)?$/)
      registry.count (count) =>
        if count > 0
          registry.each (config) =>
            if config and config['git_repo'] and config['heroku_app']
              room.speak "I know about '#{config['name']}' from '#{config['git_repo']}', pointed to '#{config['heroku_app']}' on Heroku"
        else
          room.speak "Sorry, I don't know about any apps"

    # Delete an app
    if match = message.body.match(/remove(?: the)? app (\S+)$/)
      app_name = match[1]
      success = => room.speak "Okay, '#{app_name}' is removed from this room"
      failure = => room.speak "Sorry, I don't think that app is set up for this room"
      registry.remove app_name, success, failure

module.exports = new AppRegistryResponder
