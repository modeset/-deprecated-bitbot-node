(function() {
  var app, express, port;
  express = require("express");
  app = express.createServer(express.logger());
  app.get('/', function(request, response) {
    return response.send('bleep bloop');
  });
  port = process.env.PORT || 3000;
  app.listen(port, function() {
    return console.log("Listening on " + port);
  });
}).call(this);
