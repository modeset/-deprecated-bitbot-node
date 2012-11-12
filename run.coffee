# Load libraries
Campfire = require('campfire').Campfire
Bitbot = require('./bitbot')
redis = require('redis-url').connect(process.env.REDISTOGO_URL)

# Reusable objects
client = new Campfire
  ssl:      true
  token:    process.env.CAMPFIRE_TOKEN
  account:  process.env.CAMPFIRE_ACCOUNT

# Grab the list of ignored rooms
ignored_rooms = new RegExp(process.env.EXCLUDED_ROOMS)

# Set up the Campfire room listeners
responders = require('./responders')

new Bitbot(client, responders, redis, ignored_rooms)

