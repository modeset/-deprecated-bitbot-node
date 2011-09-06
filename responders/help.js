(function() {
  exports.receiveMessage = function(message, room, client) {
    var responder, _i, _len, _ref, _results;
    if (message.body && message.body.match(/what up bot?/)) {
      room.speak("yo dawg. need some help? here's what i can do:");
      _ref = client.responders;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        responder = _ref[_i];
        _results.push((function(responder) {
          if (responder.helpMessage) {
            return room.speak(responder.helpMessage);
          }
        })(responder));
      }
      return _results;
    }
  };
}).call(this);
