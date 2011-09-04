(function() {
  exports.receiveMessage = function(message, room, client) {
    if (message.body && message.body.match(/big one|in yet|fit that in|long enough|take long|hard|pull|push/)) {
      return room.speak("TWSS");
    }
  };
}).call(this);
