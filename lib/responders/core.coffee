class Responder extends Bitbot.BaseResponder

  responderName: "Core"

  commands:
    help:
      desc: "You're looking at it (you can get help for a specific command too)"
      examples: ["help please.", "what commands do you have?", "help silence.", "help for the silence command."]
      opts:
        command: {type: "string"}

    reload:
      desc: "I'll reload my configuration and reinitialize"
      examples: ["please reload.", "I would like you to reinitialize yourself."]

    silence:
      desc: "I'll be silent for a while, only responding to commands"
      examples: ["be quiet for 20 minutes.", "shut your face!"]
      opts:
        duration: {type: "integer", default: 300}

    unsilence:
      desc: "I'll resume my normal banter after having been silenced"
      examples: ["ok, you want to join us again?", "you can resume now."]

    responders:
      desc: "List of all the responders"
      examples: ["what responders do you have?", "list of responders."]

  templates:
    unknownCommand: "Sorry {{&name}}, I don't know about the \"{{&command}}\" command. :("
    reloading: "Ok, {{&name}}, I'll be back shortly if everything goes well."
    silence: "I'm sorry.. I'll be quiet for {{&duration}} unless you ask something specific of me."
    unsilence: "Thanks!"
    helpAll: """
      ➡️ {{&botName}} Help

      Hey {{&name}}. My name is {{&botName}}, but I also respond to {{&aliases}}.
      Just prefix your commands with my name, or one of my aliases to let me know you want me to do something.

      You can say `{{&botName}} help full` to get a full list of commands, their options, and examples of usage.
      You can also ask for help for a command by saying `{{&botName}} help heroku:status` for instance.

      ☛ Available Commands\n{{#commands}}  ∙ {{&command}} {{&desc}}\n{{/commands}}
      """
    helpCommand: """
      ➡️ Command Help: {{&command}}

      {{&desc}}

      Options:\n{{#options}}  [{{&.}}]\n{{/options}}\n
      Examples:\n{{#examples}} > {{&botName}}, {{&.}}\n{{/examples}}
      """
    responders: """
      ➡️ {{&botName}} Responders

      {{#responders}}{{&responder}} {{&desc}}\n{{/responders}}
      """
    fullHelp: """
      ➡️ {{&botName}} Full Help

      I respond to {{&aliases}}. Just prefix your commands with my name, or one of my aliases to let me know you want me to do something.

      {{#commands}}
      {{&command}} {{&desc}}
                                {{#options}}
                                [{{&.}}]
                                {{/options}}

                                Examples:
                                {{#examples}}
                                 > {{&botName}}, {{&.}}
                                {{/examples}}

      {{/commands}}
      """


  help: (command) ->
    unless command then return paste: @helpForAllCommands()

    if command == 'full'
      return paste: @fullHelpForAllCommands()
    else
      for name, responder of @bot.responders
        continue unless options = responder.handler.optionsForCommand?(command)
        return paste: @t('helpCommand', _(botName: @bot.user.name).extend(@commandDescription(command, options)))

    speak: @t('unknownCommand', command: command)
    paste: @helpForAllCommands()


  reload: (callback) ->
    callback(speak: @t('reloading'))
    room.speak("Reloading.") for id, room of @bot.rooms
    @bot.reload()


  silence: (duration) ->
    redis.set("#{@message.room.id}-muted", true)
    redis.expire("#{@message.room.id}-muted", duration)
    speak: @t('silence', duration: @humanDuration(duration))


  unsilence: ->
    redis.del("#{@message.room.id}-muted", true)
    speak: @t('unsilence')


  responders: ->
    paste: @t('responders', botName: @bot.user.name, responders: @responderList())


  # private


  helpForAllCommands: ->
    @t('helpAll', botName: @bot.user.name, aliases: @bot.respondsTo.join(', or '), commands: @commandList())


  fullHelpForAllCommands: ->
    core = []
    other = []

    for name, responder of @bot.responders
      handler = responder.handler
      for command, options of handler.commands || {}
        continue unless options.desc
        desc = @commandDescription(command, options)
        registered =
          command: @padRight([handler.commandPrefix, command].join(':').replace(/^:/, ''))
          desc: options.desc
          options: desc.options
          examples: desc.examples
        (if /:/.test(registered.command) then other else core).push(registered)

    @t('fullHelp', botName: @bot.user.name, aliases: @bot.respondsTo.join(', or '), commands: core.concat(other))


  commandDescription: (command, options = {}) ->
    optionsArray = for opt, opts of options.opts || {}
      str = "#{opt.toUpperCase()} #{opts.type || 'string'}"
      str += " default:#{opts.default}" if opts.default
      str += " (#{opts.note})" if opts.note
      str

    command: command
    desc: options.desc || 'No description provided'
    examples: options.examples
    options: optionsArray


  commandList: ->
    core = []
    other = []

    for name, responder of @bot.responders
      handler = responder.handler
      for command, options of handler.commands || {}
        continue unless options.desc
        registered =
          command: @padRight([handler.commandPrefix, command].join(':').replace(/^:/, ''))
          desc: options.desc
        (if /:/.test(registered.command) then other else core).push(registered)

    core.concat(other)


  responderList: ->
    for name, responder of @bot.responders
      handler = responder.handler
      continue unless handler.responderDesc
      responder: @padRight(handler.responderName || name)
      desc: handler.responderDesc



module.exports = new Responder()
