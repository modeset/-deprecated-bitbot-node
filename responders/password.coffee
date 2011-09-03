child_process  = require('child_process')

exports.helpMessage = "generate you a fresh new password when you say 'make me a password'"

exports.receiveMessage = (message, room, client) ->
  if message.body and /^make me a password/.test( message.body )
    child_process.exec('bundle exec ha-gen', (error, stdout, stderr) ->
      unless error
        room.speak 'Try this one: ' + stdout.replace(/^\s+|\s+$/g, "")
    )