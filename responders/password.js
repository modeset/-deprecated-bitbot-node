(function() {
  var child_process;
  child_process = require('child_process');
  exports.helpMessage = "generate you a fresh new password when you say 'make me a password'";
  exports.receiveMessage = function(message, room, client) {
    if (message.body && /^make me a password/.test(message.body)) {
      return child_process.exec('bundle exec ha-gen', function(error, stdout, stderr) {
        if (!error) {
          return room.speak('Try this one: ' + stdout.replace(/^\s+|\s+$/g, ""));
        }
      });
    }
  };
}).call(this);
