(function() {
  var json_client, wwwdude;
  wwwdude = require("wwwdude");
  json_client = wwwdude.createClient({
    contentParser: wwwdude.parsers.json
  });
  exports.helpMessage = "generate you a fresh new password when you say 'make me a password'";
  exports.receiveMessage = function(message, room, client) {
    if (message.body && /^make me a password/.test(message.body)) {
      return json_client.get('http://fishsticks.herokuapp.com/?wordlist=propernames').on('success', function(data, response) {
        return room.speak('Try this one: ' + data);
      });
    }
  };
}).call(this);
