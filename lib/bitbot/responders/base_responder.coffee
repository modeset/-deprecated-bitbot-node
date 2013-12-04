class BaseResponder

  log: require('../logger.coffee')

  intervals: {}
    # help: 5 * 60 * 1000

  commands: {}
    # help:
    #   desc: "You're looking at it (you can get help for a specific cammand too)"
    #   examples: ["please help", "what commands do you have?", "help for reload!"]
    #   intent: 'help'
    #   opts:
    #     command: type: 'string'

  templates: {}
    # hello: "hello {{&name}}."


  constructor: ->
    @logPrefix = "#{@responderName || 'Unknown Responder'}:"
    @templates[name] = Mustache.compile(template) for name, template of @templates


  # public api


  respondsTo: (message) ->
    for command, options of @commands || {}
      continue if !((message.body == command || message.body == "#{@commandPrefix}:#{command}") ||
        ((message.intent == command || message.intent == options.intent) && message.confidence >= 0.7))
      return command
    false


  respond: (@message, @users, callback) ->
    @respondToCommand(callback) if @message.command


  interval: (name, callback) ->
    @message = {}
    @[name]?(callback)


  respondToCommand: (callback) ->
    return unless command = @respondsTo(@message)
    options = @commands[command]

    i = 0
    args = []
    entities = @message.entities
    for name, opts of options.opts || {}
      args.push(entities[name]?.value || entities[opts.entity]?.value || entities[i]?.value || opts.default || null)
      i += 1
    args.push(callback)

    callback(@[command]?.apply(@, args))


  optionsForCommand: (command) ->
    @commands[command] || @commands[command.replace("#{@commandPrefix}:", '')]


  # helpers

  getSettings: (callback) ->
    unless @responderName
      @log("can't use settings unless a @responderName is set", 'error')
      return

    redis.get "#{@responderName.toLowerCase()}-settings", (err, settings) ->
      return callback(err, null) if err
      return callback(new Error('unable to find settings'), null) unless settings
      callback(null, JSON.parse(settings))


  setSettings: (options = {}, callback) ->
    unless @responderName
      @log("can't use settings unless a @responderName is set", 'error')
      return

    key = "#{@responderName.toLowerCase()}-settings"
    redis.get key, (err, settings = '{}') ->
      settings = JSON.parse(settings)
      redis.set key, JSON.stringify(_(settings).extend(options)), ->
        callback?()


  delay: (time, callback) ->
    setTimeout(callback, time)


  t: (name, opts = {}) ->
    ret = @templates[name]
    return @log("Unknown message #{name}", 'error') unless ret
    message = opts['originalMessage'] || @message
    user = message['user']
    (ret(_({}).extend(message, user, opts)) || '').replace(/^\s+|\s+$/, '')


  random: (array) ->
    array ||= @responses || []
    array[Math.floor(Math.random() * array.length)]


  humanDuration: (seconds) ->
    pluralize = (n, str) -> if (n > 1) then "#{n} #{str}s" else "#{n} #{str}"

    return pluralize(years, 'year') if years = Math.floor(seconds / 31536000)
    return pluralize(days, 'day') if days = Math.floor((seconds %= 31536000) / 86400)
    return pluralize(hours, 'hour') if hours = Math.floor((seconds %= 86400) / 3600)
    return pluralize(minutes, 'minute') if minutes = Math.floor((seconds %= 3600) / 60)
    return pluralize(seconds, 'second') if seconds = seconds % 60
    return "now"


  humanTime: (time, format = 'dddd, MMM Do [at] h:mma') ->
    Moment(time).format(format)


  padRight: (str = '', padding = 25) ->
    return str if str.length > padding
    str + Array(padding - str.length + 1).join(" ")



class BaseResponder.Registry
  constructor: (@key) ->


  @matching: (pattern, callback) ->
    redis.keys pattern, (err, keys = []) =>
      for key in keys
        redis.hgetall key, (err, record) ->
          record = JSON.parse(record.value || "{}") if record
          callback?(record, key)


  upsert: (token, store, callback) ->
    @fetch token, (oldStore) =>
      if oldStore
        delete(oldStore._token)
        store = _(oldStore).extend(store)
      key = "#{@key}-#{token}"
      redis.hset @key, token, key, ->
        redis.hmset(key, {value: JSON.stringify(store)}, -> callback?())



  fetch: (token, callback) ->
    redis.hgetall @key, (err, records) ->
      unless records?[token]
        callback?(null)
        return
      redis.hgetall records[token], (err, record) ->
        if record
          record = JSON.parse(record.value) if record.value
          record._token = token
        callback?(record)


  all: (collect = true, callback) ->
    redis.hgetall @key, (err, records = {}) =>
      collection = []
      return callback?(null) unless count = Object.keys(records).length

      for token, key of records
        do(token, key) =>
          redis.hgetall key, (err, record) ->
            count -= 1
            if record
              record = JSON.parse(record.value) if record.value
              record._token = token
            if collect then collection.push(record) else callback?(record, token)
            callback?(if collection.length then collection else null) if count <= 0 && collect


  remove: (token, callback) ->
    key = "#{@key}-#{token}"
    redis.hdel @key, token, ->
      redis.del(key, -> callback?())



module.exports = BaseResponder
