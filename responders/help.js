(function() {
  exports.receiveMessage = function(message, room, client) {
    var helpMsg, responder, _fn, _i, _len, _ref;
    if (message.body && message.body.match(/what up bot?/)) {
      helpMsg = 'yo dawg. need some help? i can: \n\n';
      _ref = client.responders;
      _fn = function(responder) {
        if (responder.helpMessage) {
          return helpMsg += responder.helpMessage + '\n';
        }
      };
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        responder = _ref[_i];
        _fn(responder);
      }
      return room.speak(helpMsg);
    }
  };
}).call(this);
