fs = require('fs')
request = require('request')
_eval = require('eval')

compile = (str) ->
  try str = Coffee.compile(str)
  catch e
    throw new(e)


load = (file, args...) ->
  callback = args.pop() || ->
  opts = args.pop() || {}
  fileContents = ''

  if file.match(/^https?/)
    opts.name ||= 'url'
    @log("Loading remote #{opts.name} (at \033[34m#{file}\033[37m)...")

    request file, (err, response, body) ->
      if err || response.statusCode != 200
        callback(new Error("Unable to load remote #{opts.name} (#{response.statusCode})"))
        return

      fileContents = body
      fileContents = compile(fileContents) if opts.coffee || file.match(/.coffee$/)

      try
        mod = _eval(fileContents, file, {}, true)
        callback(null, mod)
      catch err
        callback(new Error("Unable to load #{file} (#{err.message})"))

  else
    opts.name ||= 'file'
    @log("Loading local #{opts.name} (at \033[34m#{file}\033[37m)...")

    unless fs.existsSync(file)
      callback(new Error("Unable to locate #{file}"))
      return

    try
      mod = require(file)
      callback(null, mod)
    catch err
      fs.readFile file, 'utf8', (err, body) ->
        if (err)
          callback(new Error("Unable to load #{file} (#{err.message}"))
          return

        fileContents = body
        fileContents = compile(fileContents) if opts.coffee || file.match(/.coffee$/)

        callback(null, fileContents)



module.exports = load
