class UntrustedPeriodic

  constructor: (@name = '', @code = '') ->
    @script = new SandCastle(api: Path.join(root, 'lib/bitbot/sandbox_api.js')).createScript(@code)
    @script.on 'timeout', => Bitbot.log("Execution of #{@name || 'Unknown'} periodic timed out", 'error')


  main: (callback) ->
    @script.once 'exit', (err, output) =>
      if err
        Bitbot.log("#{@name || 'Unknown'} periodic had an issue in the sandbox (#{err.message})", 'error')
        return

      callback(output)

    @script.run()


module.exports = UntrustedPeriodic
