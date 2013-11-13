class UntrustedResponder

  constructor: (@name = '', @code = '') ->
    @script = new SandCastle(api: Path.join(root, 'lib/bitbot/sandbox_api.js')).createScript(@code)
    @script.on 'timeout', => Bitbot.log("Execution of #{@name || 'Unknown'} responder timed out", 'error')


  main: (message, callback) ->
    @script.once 'exit', (err, output) =>
      if err
        Bitbot.log("#{@name || 'Unknown'} responder had an issue in the sandbox (#{err.message})", 'error')
        return

      callback(output)

    @script.run(m: message)


module.exports = UntrustedResponder
