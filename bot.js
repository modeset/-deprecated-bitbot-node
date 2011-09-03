(function() {
  var app, client, creds, express, json_client, port, ranger, sys, wwwdude;
  ranger = require("ranger");
  express = require("express");
  wwwdude = require("wwwdude");
  sys = require("sys");
  creds = {
    account: "bittheory",
    api_key: "7d0bcc5744c0794e0fdaa47bb209151060039982"
  };
  client = ranger.createClient(creds.account, creds.api_key);
  app = express.createServer(express.logger());
  json_client = wwwdude.createClient({
    contentParser: wwwdude.parsers.json
  });
  app.get('/', function(request, response) {
    return response.send('bleep bloop');
  });
  port = process.env.PORT || 3000;
  app.listen(port, function() {
    return console.log("Listening on " + port);
  });
  client.rooms(function(rooms) {
    var room, _i, _len, _results;
    _results = [];
    for (_i = 0, _len = rooms.length; _i < _len; _i++) {
      room = rooms[_i];
      _results.push((function(room) {
        room.join();
        console.log('Joined ' + room.name);
        room.listen(function(message) {
          console.log('Heard ' + message.body + ' from ' + message.userId);
          if (message.body && message.body.match(/meme|what's up/)) {
            return json_client.get('http://api.automeme.net/text.json?lines=1').on('success', function(data, response) {
              return room.speak(data[0]);
            });
          }
        });
        return console.log('Listening to ' + room.name);
      })(room));
    }
    return _results;
  });
}).call(this);
