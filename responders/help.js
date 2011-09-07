(function() {
  exports.receiveMessage = function(message, room, client) {
    var helps, responder, _i, _len, _ref;
    helps = "yo dawg. need some help? here's what i can do:\n";
    if (message.body && message.body.match(/what up bot|help bit bot/)) {
      _ref = client.responders;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        responder = _ref[_i];
        if (responder.helpMessage) {
          helps += responder.helpMessage + '\n';
        }
      }
    }
    return room.speak(helps);
  };
}).call(this);
