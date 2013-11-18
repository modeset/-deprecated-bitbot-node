class BaseResponder

  responderName: 'BaseResponder'

  #intervals:
    # help: 5 * 60 * 1000

  #commands:
    # help:
    #   desc: "You're looking at it (you can get help for a specific cammand too)"
    #   examples: ["please help", "what commands do you have?", "help for reload!"]
    #   intent: 'help'
    #   opts:
    #     command: type: 'string'

  log: require('../logger.coffee')

  constructor: ->
    @logPrefix = "#{@responderName || 'Unknown Responder'}:"


  respondsTo: (message) ->
    for command, options of @commands || {}
      continue if !((message.body == command || message.body == "#{@commandPrefix}:#{command}") ||
        ((message.intent == command || message.intent == options.intent) && message.confidence >= 0.7))
      return command
    false


  respond: (@message, callback) ->
    @respondToCommand(callback) if @message.command


  respondToCommand: (callback) ->
    return unless command = @respondsTo(@message)
    options = @commands[command]

    args = []
    for name, opts of options.opts || {}
      args.push(@message.entities[name]?.value || @message.entities[opts.entity]?.value || opts.default || null)
    args.push(callback)

    callback(@[command]?.apply(@, args))


  interval: (name, callback) ->
    @message = {}
    @[name]?(callback)


module.exports = BaseResponder
