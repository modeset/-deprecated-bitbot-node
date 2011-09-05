(function() {
  var googleweather;
  googleweather = require('googleweather');
  exports.receiveMessage = function(message, room, client) {
    var placename, today, weatherCallback;
    if (message.body && /^weather for (.+)/.test(message.body)) {
      placename = /^weather for (.+)/.exec(message.body)[1];
      today = new Date();
      weatherCallback = function(current, forecast) {
        if (current) {
          room.speak("Currently it's " + (current.condition.toLowerCase()) + " - " + current.temperature + " degrees, " + current.humidity + "% humidity, wind " + current.wind.speed + current.wind.direction);
        }
        if (forecast) {
          return room.speak("Forecast is a low of " + forecast.temperature.low + ", high of " + forecast.temperature + ", and " + (forecast.conditions.toLowerCase()) + " conditions");
        }
      };
      return googleweather.get(weatherCallback, placename, "" + (today.getFullYear()) + "-" + (today.getMonth() + 1) + "-" + (today.getDate()));
    }
  };
}).call(this);
