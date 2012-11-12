Sandbox = require('sandbox')
sandbox = new Sandbox()

exports.helpMessage = "evaluate arbitrary javascript code in a sandbox when you say 'eval <code>'"

exports.receiveMessage = (message, room, bot) ->
  if message.body and /^eval (.+)/.test( message.body )
    sandbox.run /^eval (.+)/.exec(message.body)[1], ( output ) ->
      room.paste(output.result.replace( /\n/g, ' ' ))
      if output.console and output.console.length > 0
        room.paste(console_msg) for console_msg in output.console
