request = require('request')

class Responder extends Bitbot.BaseResponder

  responderName: "Heroku Status"
  responderDesc: "Provides a command and interval (every 5 minutes) for checking Heroku status."

  intervals:
    status: 5 * 60 * 1000

  commandPrefix: "heroku"

  commands:
    status:
      desc: "Check the status of Heroku"
      examples: ["check Heroku status", "is Heroku having any issues?", "what's up with Heroku?"]
      intent: "herokustatus"

  url: "https://status.heroku.com/api/v3/current-status"
  notified: false

  status: (callback) ->
    @checkHeroku (issues) =>
      if issues
        if !@notified || @message.command
          callback(speak: "Heroku is reporting issues. Check http://status.heroku.com/ for details")
        @notified = true unless @message.command
      else
        if @message.command
          callback(speak: "Heroku seems ok right now.")
        @notified = false


  checkHeroku: (callback) =>
    request @url, (err, response, body) =>
      try callback(JSON.parse(body).issues.length > 0)
      catch e
        @log(e.message, 'error')



module.exports = new Responder()
#
#module.exports =
#  respondsTo: -> true
#  respond: -> speak: 'foo'
