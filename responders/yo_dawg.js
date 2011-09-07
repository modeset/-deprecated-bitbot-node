(function() {
  exports.receiveMessage = function(message, room, client) {
    var hello_regex, random, results;
    hello_regex = /hello bit bot|yo dawg|sup bit bot|morning bit bot/;
    results = ['yo dawg', '0110100001101001', 'well hello there'];
    random = results[Math.floor(Math.random() * results.length)];
    if (message.userId !== client.bitBotId && message.body && message.body.match(hello_regex)) {
      return room.speak(random);
    }
  };
}).call(this);
