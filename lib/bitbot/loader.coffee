fs = require('fs')
request = require('request')
_eval = require('eval')

load = (file, args...) ->
  callback = args.pop() || ->
  opts = args.pop() || {}
  fileContents = ''

  if file.match(/^https?/)
    opts.name ||= 'url'
    @log("Loading remote #{opts.name} (at #{file})...")

    request file, (err, response, body) ->
      if err || response.statusCode != 200
        callback(new Error("Unable to load remote #{opts.name} (#{response.statusCode})"))
        return

      fileContents = body
      if opts.coffee || file.match(/.coffee$/)
        try fileContents = Coffee.compile(fileContents)
        catch err
          callback(new Error("Unable to compile #{opts.name} (#{err.message})"))
          return

      if opts.trusted
        try
          mod = _eval(fileContents, file, {}, true)
          callback(null, mod)
        catch err
          callback(new Error("Unable to load #{file} (#{err.message})"))
        return

      callback(null, fileContents)

  else
    opts.name ||= 'file'
    @log("Loading local #{opts.name} (at #{file})...")

    unless fs.existsSync(file)
      callback(new Error("Unable to locate #{file}"))
      return

    if opts.trusted
      try
        mod = require(file)
        callback(null, mod)
      catch err
        callback(new Error("Unable to load #{file} (#{err.message})"))
      return
    else
      fs.readFile file, 'utf8', (err, body) ->
        if (err)
          callback(new Error("Unable to load #{file} (#{err.message}"))
          return

        fileContents = body
        if opts.coffee || file.match(/.coffee$/)
          try fileContents = Coffee.compile(fileContents)
          catch err
            callback(new Error("Unable to compile #{opts.name} (#{err.message})"))
            return
        callback(null, fileContents)

module.exports = load
