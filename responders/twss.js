(function() {
  exports.receiveMessage = function(message, room, client) {
    var twss_regex;
    twss_regex = /big one|in yet|fit that in|long enough|take long|hard|pull|push/;
    if (message.body && message.body.match(twss_regex)) {
      return room.speak("TWSS");
    }
  };
}).call(this);
