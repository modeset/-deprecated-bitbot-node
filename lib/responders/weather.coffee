request = require('request')

class Responder extends Bitbot.BaseResponder

  token: process.env["WUNDERGROUND_TOKEN"]

  responderName: "Weather"
  responderDesc: "Provides weather information for a given location."

  commandPrefix: "weather"

  commands:
    conditions:
      desc: "Displays current conditions for a given location"
      examples: ["Denver CO weather", "weather for Denver CO", "current conditions for Denver"]
      intent: "weatherconditions"
      opts:
        location: {type: 'string', default: 'Denver, CO'}

    forecast:
      desc: "Fetches a weather forecast for a given location"
      examples: ["what's the forecast for Denver CO?", "Denver CO forecast"]
      intent: "weatherforecast"
      opts:
        location: {type: "string", default: "Denver, CO"}

    moon:
      desc: "Displays the moon phase information for a given location"
      examples: ["Denver CO moon", "moon for Denver CO", "moon phase for Denver"]
      intent: "weathermoon"
      opts:
        location: {type: "string", default: "Denver, CO"}

  templates:
    unknownLocation: "Sorry {{&initials}}, I couldn't resolve {{&location}} to a known location. :("
    badService: "Sorry {{&name}}, but the weather service doesn't seem to be working."
    conditions: "Current conditions for \"{{&location}}\":\n{{&icon}} {{&weather}}. {{&temp}} (feels like {{&feelsLike}}). Wind {{&wind}}, with {{&humidity}} relative humidity."
    forecast: "Forecast for \"{{&location}}\":\n{{&icon}} {{&forecast}}"
    moon: "Current moon phase for \"{{&location}}\":\n{{&icon}} The moon is currently in the {{&phase}} phase."


  conditions: (location, callback) ->

    @resolve 'conditions', location, (url, body) =>
      return callback(speak: @t('unknownLocation', location: location)) unless url
      return callback(speak: @t('badService')) unless body

      try info = JSON.parse(body)['current_observation']
      catch e
        callback(speak: @t('badService'))

      message = @t 'conditions',
        location: location
        icon: @weatherIcon(info['icon'])
        weather: info['weather']
        temp: "#{info['temp_f']}F/#{info['temp_c']}C"
        feelsLike: "#{info['feelslike_f']}F/#{info['feelslike_c']}C"
        wind: info['wind_string']
        humidity: info['relative_humidity']
      callback(speak: message)


  forecast: (location, callback) ->
    @resolve 'forecast', location, (url, body) =>
      return callback(speak: @t('unknownLocation', location: location)) unless url
      return callback(speak: @t('badService')) unless body

      try info = JSON.parse(body)['forecast']['txt_forecast']['forecastday'][0]
      catch e
        callback(speak: @t('badService'))

      message = @t 'forecast',
        location: location
        icon: @weatherIcon(info['icon'])
        forecast: info['fcttext'].replace(' mph ', ' MPH ')
      callback(speak: message)


  moon: (location, callback) ->
    @resolve 'astronomy', location, (url, body) =>
      return callback(speak: @t('unknownLocation', location: location)) unless url
      return callback(speak: @t('badService')) unless body

      try info = JSON.parse(body)['moon_phase']
      catch e
        callback(speak: @t('badService'))

      message = @t 'moon',
        location: location
        icon: @moonIcon(info['phaseofMoon'])
        phase: info['phaseofMoon']
      callback(speak: message)


  # private


  resolve: (resource, query, callback) ->
    request "http://autocomplete.wunderground.com/aq?query=#{query}", (err, response, body) =>
      try location = JSON.parse(body)['RESULTS'][0].l
      catch e
        callback()

      url = "http://api.wunderground.com/api/#{@token}/#{resource}#{location}.json"
      request url, (err, response, body) ->
        callback(url) if err || !body
        callback(url, body)


  weatherIcon: (icon) ->
    weatherIcons[icon] || "❔"


  moonIcon: (icon) ->
    moonIcons[icon.toLowerCase()] || "❔"


  weatherIcons =
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

  moonIcons =
    "new moon": "🌑"
    "waxing crecent": "🌒"
    "first quarter": "🌓"
    "waxing": "🌔"
    "full moon": "🌕"
    "waning gibbous": "🌖"
    "last quarter": "🌗"
    "waning crescent": "🌘"



module.exports = new Responder()
