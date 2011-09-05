(function() {
  var celsiusToFahrenheit, googleweather;
  googleweather = require('googleweather');
  celsiusToFahrenheit = function(celsius) {
    return Math.round((celsius * (9 / 5)) + 32);
  };
  exports.receiveMessage = function(message, room, client) {
    var placename, today, weatherCallback;
    if (message.body && /^weather for (.+)/.test(message.body)) {
      placename = /^weather for (.+)/.exec(message.body)[1];
      today = new Date();
      weatherCallback = function(current, forecast) {
        if (current) {
          room.speak("Currently it's " + (current.condition.toLowerCase()) + " - " + (celsiusToFahrenheit(current.temperature)) + " degrees, " + current.humidity + "% humidity, wind " + current.wind.speed + current.wind.direction);
        }
        if (forecast) {
          return room.speak("Forecast is a low of " + (celsiusToFahrenheit(forecast.temperature.low)) + ", high of " + (celsiusToFahrenheit(forecast.temperature)) + ", and " + (forecast.conditions.toLowerCase()) + " conditions");
        }
      };
      return googleweather.get(weatherCallback, placename, today.toISODate());
    }
  };
}).call(this);
