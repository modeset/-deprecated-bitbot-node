(function() {
  var json_client, wwwdude;
  wwwdude = require("wwwdude");
  json_client = wwwdude.createClient({
    contentParser: wwwdude.parsers.json
  });
  exports.helpMessage = "recommend you some music when you say 'find me some <mood> tunes'";
  exports.receiveMessage = function(message, room) {
    var mood, msg_regex, regex_results, request_url;
    msg_regex = /^find me some (.+) tunes/;
    if (message.body && msg_regex.test(message.body)) {
      regex_results = msg_regex.exec(message.body);
      mood = regex_results[1];
      request_url = "http://developer.echonest.com/api/v4/song/search?api_key=" + process.env.ECHONEST_API_KEY + "&format=json&results=1&mood=" + mood + "&sort=artist_familiarity-desc";
      return json_client.get(request_url).on('success', function(data, response) {
        var song;
        if (data.response.songs.length > 0) {
          song = data.response.songs[0];
          return room.speak("try " + song.title + " by " + song.artist_name);
        } else {
          return room.speak("sorry, couldn't find any " + mood + " music for you");
        }
      });
    }
  };
}).call(this);
