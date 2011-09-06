googleweather = require('googleweather')

exports.helpMessage = "tell you the weather when you say 'weather for <location>'"

celsiusToFahrenheit = (celsius) ->
  return Math.round((celsius * (9 / 5)) + 32)

exports.receiveMessage = (message, room, client) ->
  if message.body and /^weather for (.+)/.test( message.body )
    placename = /^weather for (.+)/.exec(message.body)[1]
    today = new Date()
    weatherCallback = (current, forecast) ->
      if current
        room.speak("currently #{placename} is #{current.condition.toLowerCase()} - #{celsiusToFahrenheit(current.temperature)} degrees, #{current.humidity}% humidity, wind #{current.wind.speed}#{current.wind.direction}")
      if forecast
        room.speak("forecast is a low of #{celsiusToFahrenheit(forecast.temperature.low)}, high of #{celsiusToFahrenheit(forecast.temperature.high)}, and #{forecast.condition.toLowerCase()} conditions")
    googleweather.get(weatherCallback, placename, today.toISODate())