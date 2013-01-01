request = require('request')
exports.helpMessage = "Tell you the current weather or forecast when you say 'weather for <location>' or 'forecast for <location>'"

class WeatherFetcher

  forecast: (query, callback) =>
    @findLocation query, (loc) =>
      if loc
        request "http://api.wunderground.com/api/#{process.env.WUNDERGROUND_API_KEY}/forecast#{loc}.json", (error, resp, body) =>
          json = JSON.parse(body).forecast.txt_forecast
          callback.call @, json.forecastday[0].fcttext
      else
        callback.call @, "Sorry, I couldn't find that location"

  conditions: (query, callback) =>
    @findLocation query, (loc) =>
      if loc
        request "http://api.wunderground.com/api/#{process.env.WUNDERGROUND_API_KEY}/conditions#{loc}.json", (error, resp, body) =>
          json = JSON.parse(body).current_observation
          callback.call @, "Current weather in #{json.display_location.full} is #{json.weather.toLowerCase()}, temperature is #{json.temperature_string}, winds #{json.wind_string.toLowerCase()}, #{json.relative_humidity} relative humidity"
      else
        callback.call @, "Sorry, I couldn't find that location"

  findLocation: (query, callback) =>
    request "http://autocomplete.wunderground.com/aq?query=#{query}", (error, response, body) =>
      json = JSON.parse(body)['RESULTS']
      if json?.length
        callback.call(@, json[0].l)
      else
        callback.call(@, null)

exports.receiveMessage = (message, room, bot) ->
  return unless message?.body

  placename = null
  action = 'conditions'
  if match = message.body.match /weather for (.+)$/
    placename = match[1]
  else if match = message.body.match /forecast for (.+)$/
    action = 'forecast'
    placename = match[1]
  else if match = message.body.match /how's the weather|is it nice outside|what's the weather/
    placename = "Denver, CO"
  if placename
    (new WeatherFetcher)[action].call @, placename, (msg) -> room.speak(msg)
