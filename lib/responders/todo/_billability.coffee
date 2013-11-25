class Responder extends Bitbot.BaseResponder

  responderName: "Billability"
  responderDesc: "Provides the latest billability statistics for everyone, or just an individual."

  commandPrefix: "billability"

  commands:
    stats:
      desc: "Provides billability stats for everyone or just an individual"
      examples: ["billability?", "bill stats for Name", "what's our billability?", "what's the billability of Name?"]
      intent: 'billabilitystats'
      opts:
        member: type: "string", entity: "contact"

  url: 'https://modeset-metrics.herokuapp.com/api/billability/current.json'
  token: process.env['MODESET_METRICS_TOKEN']

  stats: (member, callback) ->
    callback(speak: "Crunching those numbers.. I'll let you know when I'm done.")
    request @url, headers: {Authorization: "Token token=#{@token}"}, (err, response, body) =>
      return callback(speak: "Sorry #{@message.user.initials}, but the service seems broken. :(") if err || body == '[]'
      try
        json = JSON.parse(body)
        week = new Date(json[0].week)
        response = "📈 Billability for the week of #{week.getMonth() + 1}/#{week.getDate()}.\n\n"

        for item in json
          response += "  ∙ #{item.name + Array(20 - item.name.length + 1).join(" ")} #{item.hours} / #{Math.floor(parseFloat(item.billability * 100))}% billable\n"

        callback(paste: "#{response}")
      catch e
        @log(e, 'error')
        callback(speak: "Sorry #{@message.user.initials}, something went wrong and I couldn't retrieve the current stats.")


module.exports  = new Responder()
