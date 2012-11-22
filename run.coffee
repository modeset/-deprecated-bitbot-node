# Load libraries
Campfire  = require('campfire').Campfire
Bitbot    = require('./bitbot')
redis     = require('redis-url').connect(process.env.REDISTOGO_URL)
_         = require('underscore');

# Reusable objects
client = new Campfire
  ssl:      true
  token:    process.env.CAMPFIRE_TOKEN
  account:  process.env.CAMPFIRE_ACCOUNT

ignored_rooms = new RegExp(process.env.EXCLUDED_ROOMS)
responders    = require('./responders')
console.log 'Loaded responders', _(responders).keys()
periodics     = require('./periodics')
console.log 'Loaded periodics', _(periodics).keys()

new Bitbot(client, responders, periodics, redis, ignored_rooms)

