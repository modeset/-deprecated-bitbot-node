(function() {
  exports.receiveMessage = function(message, room, client) {
    var hello_regex;
    hello_regex = /hello bit bot|yo dawg|sup bit bot|morning bit bot/;
    if (message.body && message.body.match(hello_regex)) {
      return room.speak("yo dawg");
    }
  };
}).call(this);
