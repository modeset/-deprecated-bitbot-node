# Load libraries
Campfire = require('campfire').Campfire

# Reusable objects
client = new Campfire
  ssl:      true
  token:    process.env.CAMPFIRE_TOKEN
  account:  process.env.CAMPFIRE_ACCOUNT

# Set up the Campfire room listeners
client.responders = [
  require('./responders/js_sandbox'),
  require('./responders/meme'),
  require('./responders/help'),
  require('./responders/password'),
  require('./responders/twss'),
  require('./responders/weather'),
  require('./responders/foursquare'),
  require('./responders/laters'),
  require('./responders/yo_dawg'),
  require('./responders/muzak')
  require('./responders/beer')
  require('./responders/fuck_that')
  require('./responders/haters')
  require('./responders/whois')
  require('./responders/bummer')
]

client.me (error,response) ->
  user = response.user
  console.log 'Got bot info', user
  client.bitBotId = user.id

client.rooms (error, rooms) ->
  for room in rooms
    do (room) ->
      unless room.name.match(new RegExp(process.env.EXCLUDED_ROOMS))
        room.join ->
          console.log 'Joined ' + room.name
          room.listen (message) ->
            console.log room.name + ': heard ' + message.body + ' from ' + message.userId
            responder.receiveMessage(message, room, client) for responder in client.responders
          console.log 'Listening to ' + room.name
