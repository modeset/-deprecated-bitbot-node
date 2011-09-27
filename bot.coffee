# Load libraries
ranger  = require("ranger")

# Set up chat client
client = ranger.createClient(process.env.CAMPFIRE_ACCOUNT, process.env.CAMPFIRE_TOKEN)

# Set up redis client
# redis = {}
# if process.env.REDISTOGO_URL
#   rtg   = require("url").parse(process.env.REDISTOGO_URL)
#   redis = require("redis").createClient(rtg.port, rtg.hostname)
# 	redis.auth(rtg.auth.split(":")[1])
# else
#   redis = require("redis").createClient()

# Bot class
class Bot
	constructor: (@client) ->
		@responders = [] 
		@setOwnId()

	addResponder: (responder) ->
		console.log "Added responder #{responder.name}" if responder.name
		@responders.push responder 
		
	setOwnId: ->
		@client.me (user) =>
			@bitBotId = user.id
		
	join: (room) ->
		room.join ->
    	console.log('Joined ' + room.name)
			room.listen (message) ->
				console.log(room.name + ': heard ' + message.body + ' from ' + message.userId)
				respond(message)
			console.log('Listening to ' + room.name)
			
  respond: (message) ->
	  for responder in @responders
      do (responder) =>
				if (message.user.id == @bitBotId)
        responder.receiveMessage(message, room, client)
		
	bindRooms: ->
		@client.rooms (rooms) ->
		  join room for room in rooms
		
# Set up the bot and responders
bot = new Bot(client)
bot.addResponder require('./responders/js_sandbox')
bot.addResponder require('./responders/meme')
bot.addResponder require('./responders/help')
bot.addResponder require('./responders/password')
bot.addResponder require('./responders/twss')
bot.addResponder require('./responders/weather')
# bot.addResponder require('./responders/foursquare')
bot.addResponder require('./responders/laters')
bot.addResponder require('./responders/yo_dawg')
bot.addResponder require('./responders/muzak')
bot.addResponder require('./responders/beer')
bot.addResponder require('./responders/fuck_that')

# Set up the Campfire room listeners
bot.bindRooms()
