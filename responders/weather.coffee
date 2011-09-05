googleweather = require('googleweather')

exports.receiveMessage = (message, room, client) ->
  if message.body and /^weather for (.+)/.test( message.body )
    placename = /^weather for (.+)/.exec(message.body)[1]
    today = new Date()
    weatherCallback = (current, forecast) ->
      if current
        room.speak("Currently it's #{current.condition.toLowerCase()} - #{current.temperature} degrees, #{current.humidity}% humidity, wind #{current.wind.speed}#{current.wind.direction}")
      if forecast
        room.speak("Forecast is a low of #{forecast.temperature.low}, high of #{forecast.temperature}, and #{forecast.conditions.toLowerCase()} conditions")
    googleweather.get(weatherCallback, placename, "#{today.getFullYear()}-#{today.getMonth() + 1}-#{today.getDate()}")