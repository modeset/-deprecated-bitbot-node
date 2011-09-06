express = require("express")
app = express.createServer(express.logger())

# Set up the express listener
app.get('/', (request, response) ->
  response.send('bleep bloop')
)

port = process.env.PORT || 3000

app.listen(port, ->
  console.log("Listening on " + port)
)