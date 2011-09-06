(function() {
  var foursquare, geo;
  geo = require("geo");
  foursquare = require("node-foursquare")({
    "secrets": {
      "clientId": "VHSYCVBSFG20NNSAMIHOAF2AXC5HXXK0EFLRTZS0RTFT21FB",
      "clientSecret": "SJZMIGADBMRAIEIMHV1I2TKZORDJLANSM5M2ILPHTBYMQGWV",
      "redirectUrl": "http://bitbot.heroku.com/callback"
    }
  });
  exports.helpMessage = "find you nearby coffee/food/booze when you say 'find me <thing> near <location>'";
  exports.receiveMessage = function(message, room, client) {
    var location, msg_regex, regex_results, thing;
    msg_regex = /^find me (.+) near (.+)/;
    if (message.body && msg_regex.test(message.body)) {
      regex_results = msg_regex.exec(message.body);
      thing = regex_results[1];
      location = regex_results[2];
      return geo.geocoder(geo.google, location, false, function(address, latitude, longitude) {
        var opts;
        if (address) {
          opts = {
            section: thing,
            limit: 50
          };
          console.log(address, latitude, longitude, opts);
          return foursquare.Venues.explore(latitude, longitude, opts, null, function(error, data) {
            var randomIndex, speakText, venue;
            if (data.groups[0].items.length > 0) {
              randomIndex = Math.floor(Math.random() * data.groups[0].items.length);
              venue = data.groups[0].items[randomIndex].venue;
              speakText = "Try " + venue.name;
              if (venue.location.address) {
                speakText += " at " + venue.location.address;
              }
              return room.speak(speakText);
            } else {
              return room.speak("Sorry, couldn't find any " + thing + " near " + address);
            }
          });
        } else {
          return room.speak("Sorry, couldn't find any " + thing + " near " + location);
        }
      });
    }
  };
}).call(this);
