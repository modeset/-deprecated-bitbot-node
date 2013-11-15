request = require('request')

class Responder extends Bitbot.BaseResponder

  responderName: "Weather"
  responderDesc: "Provides weather information for a given location."

  commandPrefix: "weather"

  commands:
    forecast:
      desc: "Fetches a weather forecast for a given location"
      examples: ["what's the forecast for Denver CO?", "Denver CO forecast"]
      intent: "weatherforecast"
      opts:
        location: type: 'string', default: 'Denver, CO'

    conditions:
      desc: "Displays current conditions for a given location"
      examples: ["Denver CO weather", "weather for Denver CO", "current conditions for Denver"]
      intent: "weatherconditions"
      opts:
        location: type: 'string', default: 'Denver, CO'

  token: process.env['WUNDERGROUND_API_TOKEN']

  iconMap:
    chancerain: "☔️❔"
    chancetstorms: "⚡️❔"
    chanceflurries: "❄️❔"
    chancesleet: "❄️❔"
    chancesnow: "❄️❔"
    mostlysunny: "☀️"
    mostlycloudy: "☁️"
    partlysunny: "⛅️"
    partlycloudy: "⛅️"
    clear: "☀️"
    sunny: "☀️"
    hazy: "☀️"
    fog: "☁️"
    cloudy: "☁️"
    rain: "☔️"
    tstorms: "⚡️"
    flurries: "❄️"
    sleet: "❄️"
    snow: "❄️"

  forecast: (locationQuery, callback) ->
    @findLocation locationQuery, (err, location) =>
      return callback(speak: "Sorry #{@message.user.initials}, I couldn't locate \"#{locationQuery}\". :(") if err
      request "http://api.wunderground.com/api/#{@token}/forecast#{location}.json", (err, response, body) =>
        try
          weather = JSON.parse(body)['forecast']['txt_forecast']['forecastday'][0]
          conditions = weather['fcttext']
          callback(speak: "Forecast for \"#{locationQuery}\":\n#{@iconFor(weather.icon)} #{conditions}")
        catch e
          @log(e.message, 'error')
          callback(speak: "Sorry #{@message.user.name}, something's wrong with the weather service. :(")


  conditions: (locationQuery, callback) ->
    @findLocation locationQuery, (err, location) =>
      return callback(speak: "Sorry #{@message.user.initials}, I couldn't locate \"#{locationQuery}\". :(") if err
      request "http://api.wunderground.com/api/#{@token}/conditions#{location}.json", (err, response, body) =>
        try
          weather = JSON.parse(body)['current_observation']
          conditions = "#{weather.weather}. #{weather.temp_f}F (feels like #{weather.feelslike_f}F)."
          conditions += " Wind #{weather.wind_string}, #{weather.relative_humidity} relative humidity."
          callback(speak: "Current conditions for \"#{locationQuery}\":\n#{@iconFor(weather.icon)} #{conditions}")
        catch e
          console.log(e)
          callback(speak: "Sorry #{@message.user.name}, something's wrong with the weather service. :(")


  iconFor: (icon) ->
    @iconMap[icon] || "❔"


  findLocation: (query, callback) ->
    request "http://autocomplete.wunderground.com/aq?query=#{query}", (err, response, body) ->
      callback(err, null) if err
      try callback(null, JSON.parse(body)['RESULTS'][0].l)
      catch e
        callback(new Error("Unable to parse response"), null)


module.exports = new Responder()
