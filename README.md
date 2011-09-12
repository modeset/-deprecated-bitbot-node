# Bitbot

A Campfire bot for Bit Theory

## What it can do currently
* Hit you back with a random meme anytime you mention the word "meme"
* Evaluate javascript code in a sandbox
* Tell you what it can do
* TWSS
* Weather
* Find nearby stuff (based on Foursquare venues)
* Music suggestions

## What it should do
* Respond to its name
* Greet people in the morning
* Repeat the last command
* Meeting reminders
* Highrise reminders
* Deployments
* Tracker status
* EY status
* Newrelic/Hoptoad status
* Animated GIFs
* Mustachified pictures
* Posts to/from Lazy Standup
* Snow report
* Daily project status updates (analytics, traffic, etc..)
* HTTP request console stuff
* Heroku scaling
* Automatically check its status and restart itself if needed
* Automatically join new rooms
* Be able to turn off responders for specific rooms

## How it works
* Written in [Node](nodejs.org) and [Coffeescript](http://jashkenas.github.com/coffee-script/).
* Uses [Ranger](https://github.com/mrduncan/ranger) for Campfire integration
* Uses [Express](http://expressjs.com/) to provide a Heroku frontend
* Uses [wwwdude](https://github.com/pfleidi/node-wwwdude) for HTTP client interactions
* Uses [sandbox](http://gf3.github.com/sandbox/) for sandboxing JS execution
* Uses [environment variables](http://devcenter.heroku.com/articles/config-vars) to set its credentials for Campfire, Foursquare, Echonest, etc.

## Building
* have node and npm installed
* run `npm link`
* code like the badass you are (and include specs)
* run `cake spec`
* git commit, push
* then deploy to heroku (`git push production|heroku master`)
