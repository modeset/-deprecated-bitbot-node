request = require('request')

class Responder extends Bitbot.BaseResponder

  responderName: "Snow Report"
  responderDesc: "Provides snow reports for colorado resorts."

  commandPrefix: "snow"

  commands:
    report:
      desc: "Provides a snow report for a given resort"
      examples: ["snow report for Copper Mountain?", "what's the snow like at snowmass"]
      intent: "snowreport"
      opts:
        resort: type: "string", entity: "location"

  state: "Colorado"
  url: "https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&num=100&q=http://www.onthesnow.com/{{state}}/snow.rss"

  report: (resort, callback) ->
    unless resort
      return speak: "Sorry #{@message.user.initials}, you need to provide a resort for this command."
    request @url.replace('{{state}}', @state.toLowerCase()), (err, response, body) =>
      try
        entries = JSON.parse(body)['responseData']['feed']['entries']
        result = _(entries).find (entry) -> entry.title.toLowerCase().indexOf(resort.toLowerCase()) >= 0
        unless result
          return callback(speak: "Sorry #{@message.user.name}, I couldn't find a resort named \"#{resort}\" in #{@state}.")
        response = """
        Snow report for "#{result.title}" (as of #{Moment(result.publishedDate).format('dddd, MMMM Do [at] h:mma')}):
        ⛄️ #{result.content}
        """
        callback(speak: response)
      catch e
        @log(e, 'error')
        callback(speak: "Sorry #{@message.user.name}, something went wrong in the responder. :L")


module.exports  = new Responder()
