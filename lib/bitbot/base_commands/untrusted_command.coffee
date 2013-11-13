class UntrustedCommand

  constructor: (@name = '', @code = '') ->
    @script = new SandCastle(api: Path.join(root, 'lib/bitbot/sandbox_api.js')).createScript(@code)
    @script.on 'timeout', => Bitbot.log("Execution of #{@name || 'Unknown'} command timed out", 'error')


  main: (message, callback) ->
    @script.once 'exit', (err, output) =>
      if err
        Bitbot.log("#{@name || 'Unknown'} command had an issue in the sandbox (#{err.message})", 'error')
        return

      callback(output)

    @script.run(m: message)


module.exports = UntrustedCommand
