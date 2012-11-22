# Load libraries
Campfire  = require('campfire').Campfire
Bitbot    = require('./bitbot')
redis     = require('redis-url').connect(process.env.REDISTOGO_URL)

# Reusable objects
client = new Campfire
  ssl:      true
  token:    process.env.CAMPFIRE_TOKEN
  account:  process.env.CAMPFIRE_ACCOUNT

ignored_rooms = new RegExp(process.env.EXCLUDED_ROOMS)
responders    = require('./responders')
periodics     = require('./periodics')

new Bitbot(client, responders, periodics, redis, ignored_rooms)

