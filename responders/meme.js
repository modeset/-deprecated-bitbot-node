(function() {
  var json_client, wwwdude;
  wwwdude = require("wwwdude");
  json_client = wwwdude.createClient({
    contentParser: wwwdude.parsers.json
  });
  exports.helpMessage = "make you a fresh meme when you say 'meme'";
  exports.receiveMessage = function(message, room) {
    if (message.body && message.body.match(/meme/)) {
      return json_client.get('http://api.automeme.net/text.json?lines=1').on('success', function(data, response) {
        return room.speak(data[0]);
      });
    }
  };
}).call(this);
