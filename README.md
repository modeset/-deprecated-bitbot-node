Bitbot
======

[![Build Status](https://travis-ci.org/modeset/bitbot.png?branch=master)](https://travis-ci.org/modeset/bitbot)

A Campfire bot from Mode Set.

## Installation

```shell
nmp install bitbot@">=0.1.0"
```

## Setup

Bitbot requires a few environment variables. `CAMPFIRE_ACCOUNT` and `REDISTOGO_URL` are required. Redis is used to allow responders etc. to keep track of their own settings and variables.

```shell
export CAMPFIRE_ACCOUNT=[your campfire account]
export REDISTOGO_URL=[your redistogo url]
```

You'll also need a configuration file, and you can [grab an example here](http://github.com/modeset/bitbot/master/example_config.json). Put this file in your project and make your adjustments. Check the wiki for more [information about configuration](https://github.com/modeset/bitbot/wiki/Configuration). Configuration can also be specified by providing a url instead of a file path.

**Note:** Tokens can be specified in the configuration directly, but it's advisable to use environment variables for your bot tokens. You can set an environment variable and change the configuration to point to that by setting the token to `>YOUR_ENV_VAR`.


## Usage

Now that you have the environment variables and some bots setup in the configuration, you should be able to run `bitbot` with your configuration -- you should see campfire connection info, rooms joined, and the responders etc. that were loaded.

```shell
bitbot config.json
```


## Commands

Commands are core behaviors that will allow you to control your bot. All commands must be prefixed with the bots name or as configured in `respondsTo`.

```
Bit Bot: reload!
Bit Bot reload!
```

### Default commands

- help! - display the help for all commands.
- reload! - reload the configuration and reinitialize the bot (joining new rooms / leaving any that were removed).
- silence! - remain in silenced mode until someone says to resume.
- resume! - go ahead and continue talking.


## Responders

Responders are for casual conversation and don't require addressing the bot directly. All responders are notified of any conversational messages and can determine how to respond themselves. This typically takes the form of a regular expression and a response.

The SimpleResponder is a good example of a regexp and random responses when a message contains something that matches.

### Default responders


## Periodics

Periodics are basically timers. You can specify a periodic that will execute every N seconds in the configuration, and it will be triggered on that interval.

### Default periodics


## Roadmap

### Core
- Be able to remember arbitrary things (api tokens, etc)
- Announce its starts/stops

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
- code like the badass you are
- run `npm test` to make sure all existing, and new, specs pass
- git commit, push


## License

Licensed under the [MIT License](http://creativecommons.org/licenses/MIT/)

Copyright 2012 [Mode Set](https://github.com/modeset)


## Make Code Not War

![crest](https://secure.gravatar.com/avatar/aa8ea677b07f626479fd280049b0e19f?s=75)


trusted_periodic.coffee
count = 0

exports.main = (callback = exit) ->
  callback(paste: "Remote trusted periodic (notified #{count + 1} #{if (count += 1) == 1 then 'time' else 'times'})")


trusted_responder.coffee
responder = new Bitbot.SimpleResponder(/bot/, ["I'm a remote trusted simple responder, what can I help you with?"])

exports.main = (message = m, room = r, callback = exit) ->
  responder.main(message, room, callback)



untrusted_periodic.coffee
count = 0

exports.main = (callback = exit) ->
  callback(paste: "Remote untrusted periodic (notified #{count + 1} #{if (count += 1) == 1 then 'time' else 'times'})")


untrusted_responder.coffee
