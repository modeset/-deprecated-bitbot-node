(function() {
  exports.receiveMessage = function(message, room, client) {
    var hello_regex;
    hello_regex = /laters bit bot|night bit bot/;
    if (message.userId !== client.bitBotId && message.body && message.body.match(hello_regex)) {
      return room.speak("g'night slacker");
    }
  };
}).call(this);
