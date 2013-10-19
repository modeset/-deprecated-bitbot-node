Bitbot
======

[![Build Status](https://travis-ci.org/modeset/bitbot.png?branch=master)](https://travis-ci.org/modeset/bitbot)

A Campfire bot from Mode Set.

## Installation

```shell
nmp install bitbot@">=0.1.0"
```

## Setup

Bitbot requires a few environment variables to be set before use.

```shell
export CAMPFIRE_TOKEN=[your campfire token]
export CAMPFIRE_ACCOUNT=[your campfire account]
```

You can optionally pass a configuration file when starting Bitbot by passing its path to the `bitbot` command. This can
be a remote url if needed.

```shell
bitbot config.json
```

```shell
bitbot https://gist.github.com/jejacks0n/7058593#file-bitbot_config-json
```

You should now be able to run `bitbot` and see the bot information, rooms joined, and the responders/periodics that have
been loaded.


## Configuration


## Commands

Bitbot has the concept of core commands. These commands are only available to those who are specified as "ops" in the
configuration.

## Responders

- Hit you back with a random meme anytime you mention the word "meme"
- Evaluate javascript code in a sandbox
- Tell you what it can do
- Weather (via Weather Underground)
- Find nearby stuff (based on Foursquare venues)
- Music suggestions (based on Echonest, though the data's a bit suspect)
- Take credit for other people's thanks
- Repeat the last command
- Snow reports and forecasts (Colorado-only for now)
- Heroku deployments


## Advanced Responders


## Periodics


## Current Responders


## Roadmap

### Libraries
- Swap in request.js for Shred

### Core
- Automatically check its status and restart itself if needed
- Automatically join new rooms
- Be able to turn off responders for specific rooms
- Be able to remember arbitrary things (api tokens, etc)
- Announce its own deployments and starts/stops

### Responders
- Pull Github status updates from https://twitter.com/githubstatus
- Play integration
- Timesheet reminders
- Greet people in the morning
- Meeting reminders
- Highrise reminders
- Tracker status
- Newrelic/Airbrake status
- Mustachified pictures
- Daily project status updates (analytics, traffic, etc..)


## Development

Written in [node.js](nodejs.org) and [coffeescript](http://jashkenas.github.com/coffee-script/).

- have node and npm installed
- clone the project
- run `npm install && npm link`
- code like the badass you are (and include specs)
- run `cake spec` to make sure all the specs pass
- git commit, push
- deploy


## License

Licensed under the [MIT License](http://creativecommons.org/licenses/MIT/)

Copyright 2012 [Mode Set](https://github.com/modeset)


## Make Code Not War
![crest](https://secure.gravatar.com/avatar/aa8ea677b07f626479fd280049b0e19f?s=75)
