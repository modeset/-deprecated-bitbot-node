(function() {
  var Sandbox, app, client, express, json_client, port, ranger, sandbox, sys, wwwdude;
  ranger = require("ranger");
  express = require("express");
  wwwdude = require("wwwdude");
  sys = require("sys");
  Sandbox = require('sandbox');
  client = ranger.createClient(process.env.CAMPFIRE_ACCOUNT, process.env.CAMPFIRE_TOKEN);
  app = express.createServer(express.logger());
  json_client = wwwdude.createClient({
    contentParser: wwwdude.parsers.json
  });
  sandbox = new Sandbox();
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
            json_client.get('http://api.automeme.net/text.json?lines=1').on('success', function(data, response) {
              return room.speak(data[0]);
            });
          }
          if (message.body && /^eval (.+)/.test(message.body)) {
            return sandbox.run(/^eval (.+)/.exec(message.body)[1], function(output) {
              var console_msg, _j, _len2, _ref, _results2;
              room.paste(output.result.replace(/\n/g, ' '));
              if (output.console && output.console.length > 0) {
                _ref = output.console;
                _results2 = [];
                for (_j = 0, _len2 = _ref.length; _j < _len2; _j++) {
                  console_msg = _ref[_j];
                  _results2.push(room.paste(console_msg));
                }
                return _results2;
              }
            });
          }
        });
        return console.log('Listening to ' + room.name);
      })(room));
    }
    return _results;
  });
}).call(this);
