(function() {
  var app, client, express, port, ranger;
  ranger = require("ranger");
  express = require("express");
  client = ranger.createClient(process.env.CAMPFIRE_ACCOUNT, process.env.CAMPFIRE_TOKEN);
  app = express.createServer(express.logger());
  app.get('/', function(request, response) {
    return response.send('bleep bloop');
  });
  port = process.env.PORT || 3000;
  app.listen(port, function() {
    return console.log("Listening on " + port);
  });
  client.responders = [require('./responders/js_sandbox'), require('./responders/meme'), require('./responders/help')];
  client.rooms(function(rooms) {
    var room, _i, _len, _results;
    _results = [];
    for (_i = 0, _len = rooms.length; _i < _len; _i++) {
      room = rooms[_i];
      _results.push((function(room) {
        room.join();
        console.log('Joined ' + room.name);
        room.listen(function(message) {
          var responder, _j, _len2, _ref, _results2;
          console.log('Heard ' + message.body + ' from ' + message.userId);
          _ref = client.responders;
          _results2 = [];
          for (_j = 0, _len2 = _ref.length; _j < _len2; _j++) {
            responder = _ref[_j];
            _results2.push((function(responder) {
              return responder.receiveMessage(message, room, client);
            })(responder));
          }
          return _results2;
        });
        return console.log('Listening to ' + room.name);
      })(room));
    }
    return _results;
  });
}).call(this);
