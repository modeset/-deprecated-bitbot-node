_ = require('underscore')
request = require('request')

class OpenSnowResponder

  constructor: (@apiKey = process.env.OPENSNOW_API_KEY) ->
    @state = 'CO'

  cacheLocations: (callback) =>
    unless @locations
      request "http://opensnow.com/api/getLocationIds.php?apikey=#{@apiKey}&state=#{@state}&type=json", (error, response, body) =>
        if error
          console.log 'Could not cache the list of locations!'
        else
          @locations = JSON.parse(body).location
          callback.call(@)
    else
      callback.call(@)

  locationByName: (name, callback) =>
    @cacheLocations =>
      searchTerm = name.toLowerCase()
      result = _(@locations).find (entry) ->
        entry.name.toLowerCase().indexOf(searchTerm) >= 0
      callback.call(@, result)

  helpMessage: "Grab a snow forecast when you say 'snow forecast for <resort>' (Colorado-only for now)"

  receiveMessage: (message, room, bot) =>
    # Abort if this is a bot message
    return if message.userId is bot.botUserId

    if message.body and /snow forecast for (.+)$/.test( message.body )
      placename = /snow forecast for (.+)$/.exec(message.body)[1].toLowerCase()
      @locationByName placename, (location) =>
        if location
          request "http://opensnow.com/api/getLocationData.php?apikey=#{@apiKey}&lids=#{location.id}&type=json", (error, response, body) ->
            unless error
              json = JSON.parse(body)
              location_name = json.location.meta.print_name
              today = json.location.forecast.period[0]
              tomorrow = json.location.forecast.period[1]
              room.speak "Ok, I found the snow forecast for #{location_name}:"
              room.speak "During the day, the forecast is '#{today.day.weather}' with a high of #{today.day.temp} and #{today.day.snow}\" of accumulation"
              room.speak "Tonight, the forecast is '#{today.night.weather}' with a low of #{today.night.temp} and #{today.night.snow}\" of accumulation"
              room.speak "Tomorrow, the forecast is '#{tomorrow.day.weather}' with a high of #{tomorrow.day.temp} and #{tomorrow.day.snow}\" of accumulation"
            else
              room.speak "Sorry, something went wrong and I couldn't retrieve that forecast"
        else
          room.speak "Sorry, I couldn't find that resort in Colorado"


module.exports = new OpenSnowResponder
