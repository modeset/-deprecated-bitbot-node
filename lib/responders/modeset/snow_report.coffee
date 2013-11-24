class Responder extends Bitbot.BaseResponder

  state: "Colorado"
  url: "https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&num=100&q=http://www.onthesnow.com/{{state}}/snow.rss"

  responderName: "Snow Report"
  responderDesc: "Provides snow reports for colorado resorts."

  commandPrefix: "snow"

  commands:
    report:
      desc: "Provides a snow report for a given resort"
      examples: ["snow report for Copper Mountain?", "what's the snow like at Snowmass?"]
      intent: "snowreport"
      opts:
        resort: type: "string", entity: "location"

  templates:
    missingResort: "Sorry {{&initials}}, you need to provide a resort for this command."
    error: "Sorry {{&name}}, something went wrong in the responder. :L"
    resortNotFound: "Sorry {{&name}}, I couldn't find a resort named \"{{&resort}}\" in {{&state}}."
    report: "Snow report for \"{{&resort}}\" (as of {{&datetime}}):\n⛄️ {{report}}"


  report: (resort, callback) ->
    unless resort then return speak: @t('missingResort')

    request @url.replace('{{state}}', @state.toLowerCase()), (err, response, body) =>
      try entries = JSON.parse(body)['responseData']['feed']['entries']
      catch e
        return callback(speak: @t('error'))

      info = _(entries).find (entry) -> entry.title.toLowerCase().indexOf(resort.toLowerCase()) >= 0
      unless info then return callback(speak: @t('resortNotFound', resort: resort, state: @state))

      message = @t 'report',
        resort: info['title']
        datetime: @humanTime(info['publishedDate'])
        report: info['content']
      callback(speak: message)



module.exports  = new Responder()
