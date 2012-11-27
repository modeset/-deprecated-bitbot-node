# Bitbot

A Campfire bot for Mode Set

## What it can do currently
* Hit you back with a random meme anytime you mention the word "meme"
* Evaluate javascript code in a sandbox
* Tell you what it can do
* TWSS
* Weather
* Find nearby stuff (based on Foursquare venues)
* Music suggestions (based on Echonest, though the data's a bit suspect)
* Take credit for other people's thanks
* Repeat the last command
* Snow report (Colorado-only for now)
* Heroku deployments

## Roadmap (wishlist in rough priority order)
* Swap in scoped-http-client for shred
* Play integration
* Automatically check its status and restart itself if needed
* Automatically join new rooms
* Timesheet reminders
* Greet people in the morning
* Meeting reminders
* Highrise reminders
* Tracker status
* Newrelic/Airbrake status
* Animated GIFs
* Mustachified pictures
* Daily project status updates (analytics, traffic, etc..)
* Be able to turn off responders for specific rooms
* Be able to remember arbitrary things (api tokens, etc)
* Announce its own deployments and starts/stops

## How it works
* Written in [node.js](nodejs.org) and [coffeescript](http://jashkenas.github.com/coffee-script/).
* Uses [node-campfire](https://github.com/mrduncan/ranger) for Campfire integration
* Uses [shred](https://github.com/automatthew/shred) for HTTP client interactions
* Uses [sandbox](http://gf3.github.com/sandbox/) for sandboxing JS execution
* Uses [jasmine](http://pivotal.github.com/jasmine) for unit tests
* Uses [environment variables](http://devcenter.heroku.com/articles/config-vars) to set its credentials for Campfire, Foursquare, Echonest, etc.

## Building
* have node and npm installed
* run `npm link`
* code like the badass you are (and include specs)
* run `cake spec` and make sure all the specs pass
* git commit, push
* then deploy to heroku (`git push production|heroku master`)
