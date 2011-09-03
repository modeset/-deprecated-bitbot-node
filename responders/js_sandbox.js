(function() {
  var Sandbox, sandbox;
  Sandbox = require('sandbox');
  sandbox = new Sandbox();
  exports.helpMessage = "evaluate arbitrary javascript code in a sandbox when you say 'eval <code>'";
  exports.receiveMessage = function(message, room, client) {
    if (message.body && /^eval (.+)/.test(message.body)) {
      return sandbox.run(/^eval (.+)/.exec(message.body)[1], function(output) {
        var console_msg, _i, _len, _ref, _results;
        room.paste(output.result.replace(/\n/g, ' '));
        if (output.console && output.console.length > 0) {
          _ref = output.console;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            console_msg = _ref[_i];
            _results.push(room.paste(console_msg));
          }
          return _results;
        }
      });
    }
  };
}).call(this);
