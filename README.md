# Bitbot

A Campfire bot for Bit Theory

## What it can do currently
* Hit you back with a random meme anytime you mention the word "meme"
* Evaluate javascript code in a sandbox
* Tell you what it can do
* TWSS

## What it should do
* Wave hi
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
* Weather
* Daily project status updates (analytics, traffic, etc..)
* Lunch suggestions
* Music suggestions

## How it works
* Written in [Node](nodejs.org) and [Coffeescript](http://jashkenas.github.com/coffee-script/).
* Uses [Ranger](https://github.com/mrduncan/ranger) for Campfire integration
* Uses [Express](http://expressjs.com/) to provide a Heroku frontend
* Uses [wwwdude](https://github.com/pfleidi/node-wwwdude) for HTTP client interactions
* Uses [sandbox](http://gf3.github.com/sandbox/) for sandboxing JS execution
* Uses [environment variables](http://devcenter.heroku.com/articles/config-vars) to set its Campfire room and token
