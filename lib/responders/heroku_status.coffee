request = require('request')

class Responder extends Bitbot.BaseResponder

  url: "https://status.heroku.com/api/v3/current-status"

  responderName: "Heroku Status"
  responderDesc: "Provides a command and interval (every 5 minutes) for checking Heroku status."

  intervals:
    status: 10 * 1000

  commandPrefix: "heroku"

  commands:
    status:
      desc: "Check the status of Heroku"
      examples: ["check Heroku status.", "is Heroku having any issues?", "what's up with Heroku?"]
      intent: "herokustatus"

  templates:
    good: "✅ Heroku isn't reporting any issues."
    bad: "⚠️ Heroku is reporting issues. Check http://status.heroku.com/ for more details."

  notified: false


  status: (callback) ->
    @checkHeroku (good) =>
      if good
        callback(speak: @t('good')) if @notified || @message.command
        @notified = false
      else
        callback(speak: @t('bad')) if !@notified || @message.command
        @notified = true unless @message.command


  checkHeroku: (callback) ->
    request @url, (err, response, body) ->
      try issues = !JSON.parse(body)['issues'].length
      catch e
        return callback(false)

      callback(issues)



module.exports = new Responder()
