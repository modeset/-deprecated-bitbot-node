(function() {
  var client, ranger;
  ranger = require("ranger");
  client = ranger.createClient(process.env.CAMPFIRE_ACCOUNT, process.env.CAMPFIRE_TOKEN);
  client.responders = [require('./responders/js_sandbox'), require('./responders/meme'), require('./responders/help'), require('./responders/password'), require('./responders/twss'), require('./responders/weather'), require('./responders/foursquare')];
  client.rooms(function(rooms) {
    var room, _i, _len, _results;
    _results = [];
    for (_i = 0, _len = rooms.length; _i < _len; _i++) {
      room = rooms[_i];
      _results.push((function(room) {
        room.join(function() {
          console.log('Joined ' + room.name);
          return room.listen(function(message) {
            var responder, _j, _len2, _ref, _results2;
            console.log(room.name + ': heard ' + message.body + ' from ' + message.userId);
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
        });
        return console.log('Listening to ' + room.name);
      })(room));
    }
    return _results;
  });
}).call(this);
