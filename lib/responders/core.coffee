class Responder extends Bitbot.BaseResponder

  responderName: 'Core'

  commands:
    help:
      desc: "You're looking at it (you can get help for a specific cammand too)"
      examples: ["please help", "what commands do you have?", "help for reload!"]
      opts:
        command: type: "string"

    reload:
      desc: "I'll reload my configuration and reinitialize"
      examples: ["please reload", "I would like you to reinitialize"]

    silence:
      desc: "I'll be silent for a while, only responding to commands"
      examples: ["be quite for 20 seconds", "shut your face"]
      opts:
        duration: type: "integer", default: 300, note: "seconds"

    resume:
      desc: "I'll resume my normal banter after having been silenced"
      examples: ["ok, you can start talking again", "good to go"]
      intent: "unsilence"

    responders:
      desc: "List of all the responders"
      examples: ["what responders do you have?", "list of responders"]

  help: (command, callback) ->
    if command
      for name, responder of @bot.responders
        handler = responder.handler
        if handler.commands
          options = handler.commands[command.replace(handler.commandPrefix + ':', '')]
          return callback(paste: @helpForCommand(command, options)) if options
      speak: "Sorry #{@message.user.name}, I don't know about the #{command} command. :("
    else
      paste: @helpForAllCommands()


  reload: ->
    @bot.reload()


  silence: (time) ->
    redis.set("#{@message.room.id}-muted", true)
    redis.expire("#{@message.room.id}-muted", time)
    speak: "I'm sorry.. I'll be quite for a while. (~#{parseInt(time / 60)} minutes)"


  resume: ->
    redis.del("#{@message.room.id}-muted", true)
    speak: 'Thanks!'


  responders: ->
    paste: """
    ➡️ #{@bot.user.name} Responders

    Hey #{@message.user.name}. This is a list of my responders.
    #{@responderList()}
    """


  helpForAllCommands: ->
    """
    ➡️ #{@bot.user.name} Help

    Hey #{@message.user.name}. My name is #{@bot.user.name}, but I also respond to #{@bot.respondsTo.join(', or ')}.
    Just prefix your commands with my name or one of my aliases to let me know you want me to do something.

    If you need help on a specific command use: "#{@bot.user.name}, help [command]"
    #{@commandList()}
    """


  helpForCommand: (command, options) ->
    ret = "☛️ Command Help: #{command}\n\n"
    ret += "#{options.desc}\n" if options.desc
    if options.opts
      ret += '\nOptions:\n'
      for opt, opts of options.opts
        ret += "  [#{opt.toUpperCase()} #{opts.type || 'string'}"
        ret += " default:#{opts.default}" if opts.default
        ret += " (#{opts.note})" if opts.note
        ret += "]\n"
    if options.examples
      ret += '\nExamples:\n'
      for example in options.examples
        ret += " > #{@bot.user.name}: #{example}\n"
    ret.replace(/\n+$/, '')


  commandList: ->
    ret = ''
    for name, responder of @bot.responders
      continue unless responder.handler.commands
      ret += "\n☛️ #{responder.handler.responderName || name} Commands"
      for command, options of responder.handler.commands
        prefix = ''
        prefix = "#{commandPrefix}:" if commandPrefix = responder.handler.commandPrefix
        command = "#{prefix}#{command}"
        ret += "\n  ∙ #{command + Array(20 - command.length + 1).join(" ")}"
        ret += " #{options.desc}" if options.desc
    ret


  responderList: ->
    ret = ''
    for name, responder of @bot.responders
      handler = responder.handler
      continue unless handler.responderDesc
      ret += "\n☛️ #{handler.responderName || name} - #{handler.responderDesc}"
    ret


module.exports = new Responder()
