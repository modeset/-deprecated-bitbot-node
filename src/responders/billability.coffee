request = require 'request'
_s      = require 'underscore.string'

exports.helpMessage = "Grab the latest billability stats when you say 'what\'s our billability?'"

exports.respond = (message, room, bot) ->
  # Abort if this is a bot message
  return if message.userId is bot.botUserId

  if message.body and message.body.match(/what('?)s our billability(\?)?$/) 
    options =
      uri: 'https://modeset-metrics.herokuapp.com/api/billability/current.json',
      headers:
        Authorization: "Token token=#{process.env.MODESET_METRICS_API_KEY}"
    request options, (error, response, body) ->
      unless error
        json = JSON.parse(body)
        week = new Date(json[0].week)
        response = "For the week of #{week.getMonth() + 1}/#{week.getDate()}, "
        response = response + _s.toSentence("#{item.name} billed #{item.hours} hours and was #{Math.floor(parseFloat(item.billability * 100))}% billable" for item in json)
        room.speak response + '.'
      else
        room.speak "Sorry, something went wrong and I couldn't retrieve the current billability stats"
