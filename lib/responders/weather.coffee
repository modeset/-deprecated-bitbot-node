class Responder extends Bitbot.BaseResponder

  responderName: "Weather"
  responderDesc: "Provides weather information for a given location."

  commandPrefix: "weather"

  commands:
    configure:
      desc: "Setup the weather service (must use the command directly)"

    conditions:
      desc: "Displays current conditions for a given location"
      examples: ["Denver CO weather", "weather for Denver CO", "current conditions for Denver"]
      intent: "weatherconditions"
      opts:
        location: {type: 'string'}

    forecast:
      desc: "Fetches a weather forecast for a given location"
      examples: ["what's the forecast for Denver CO?", "Denver CO forecast"]
      intent: "weatherforecast"
      opts:
        location: {type: "string"}

    moon:
      desc: "Displays the moon phase information for a given location"
      examples: ["Denver CO moon", "moon for Denver CO", "moon phase for Denver"]
      intent: "weathermoon"
      opts:
        location: {type: "string"}

  templates:
    notConfigured: "Looks like the weather service isn't configured. Use weather:configure to get it setup."
    configureToken: "Hi {{&initials}}, to get your weather setup I need the token. You should be able to get one at: http://www.wunderground.com/weather/api\n❓ What token should I use (current: {{&current}})?"
    configureLocation: "Okay {{&initials}}, I need a default location (eg: Denver, CO).\n❓ What default location should I use (current: {{&current}})?"
    configureSuccess: "Okay {{&name}}, all setup and ready to go."
    unknownLocation: "Sorry {{&initials}}, I couldn't resolve {{&location}} to a known location. :("
    badService: "Sorry {{&name}}, but the weather service doesn't seem to be working."
    conditions: "Current conditions for \"{{&location}}\":\n{{&icon}} {{&weather}}. {{&temp}} (feels like {{&feelsLike}}). Wind {{&wind}}, with {{&humidity}} relative humidity."
    forecast: "Forecast for \"{{&location}}\":\n{{&icon}} {{&forecast}}"
    moon: "Current moon phase for \"{{&location}}\":\n{{&icon}} The moon is currently in the {{&phase}} phase."


  constructor: ->
    @getSettings (err, @settings = {}) ->
    super


  configure: (callback, token, location) ->
    if !token
      callback speak: @t('configureToken', current: @settings.token), prompt: (message) =>
        @setSettings(token: @settings.token = message.body)
        @configure(callback, @settings.token)
    else if !location
      callback speak: @t('configureLocation', current: @settings.location), prompt: (message) =>
        @setSettings(location: @settings.location = message.body)
        @configure(callback, token, @settings.location)
    else
      callback(speak: @t('configureSuccess'))


  conditions: (location, callback) ->
    unless @settings.location then return speak: @t('notConfigured')
    location ||= @settings.location

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
    unless @settings.location then return speak: @t('notConfigured')
    location ||= @settings.location

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
    unless @settings.location then return speak: @t('notConfigured')
    location ||= @settings.location

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

      url = "http://api.wunderground.com/api/#{@settings.token}/#{resource}#{location}.json"
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
