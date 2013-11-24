Bitbot
======

[![Build Status](https://travis-ci.org/modeset/bitbot.png?branch=master)](https://travis-ci.org/modeset/bitbot)

A Campfire bot from Mode Set that uses [Wit.ai](http://wit.ai) for natural language parsing.

## Table of Contents

1. [Installation](#installation)
2. [Setup](#setup)
3. [Usage](#usage)
4. [Configuration](#configuration)
5. [Responders](#responders)
6. [Development](#coverage)


## Installation

Have node and npm installed.

```shell
git clone https://github.com/modeset/bitbot.git
cd bitbot
npm install && npm link
```


## Setup

You should already have a Campfire account, and you can setup Redis on heroku by adding the "Redis To Go" add-on (there's a free option that'll probably be enough). And of course, you can [sign up for Wit.ai here](https://wit.ai/).

There's a few environment variables that Bitbot requires before connecting, and you'll probably want to edit the configuration file. There's one at the root of the project named `[example_config.json](https://github.com/modeset/bitbot/blob/master/example_config.json)` that you can start modifying.

To add a bot you'll need to have a Campfire token (which is tied to a user). These can be specified in the configuration, or as environment variables.

```shell
export CAMPFIRE_ACCOUNT=[your campfire account]
export REDISTOGO_URL=[your redistogo url]
export WIT_TOKEN=[your wit.ai token]
export YOUR_BOT_TOKEN=[your campfire token]
```

**Note:** Bot tokens can be specified in the configuration directly, but it's advisable to use environment variables for your bot tokens. You can set an environment variable and change the configuration to point to that by setting the token to `>YOUR_BOT_TOKEN`.


## Usage

Now that you have the environment variables and some bots setup in the configuration, you should be able to run `bitbot` with your configuration -- you should see campfire connection info, rooms joined, and the responders that have loaded.

```shell
bitbot example_config.json
```

Bitbot's core behaviors are provided by Responders. They include a wide range of styles, and can be anything from a simple regexp matcher, to something more complex that understands commands, prompting for input etc.

While Bitbot ships with some useful responders, you're encouraged to come up with your own ideas and implement responders based on your specific needs.

### Core Commands

The core commands are provided by the core responder, and are primarily things that are related to Bitbot itself. This responder is special in that it understands things about the bot itself, which is not true for most responders. You'll see that this responder is specified uniquely in the configuration as well.

- help                 - Displays all commands with descriptions
- reload               - Will tell Bitbot to reload its configuration and reinitialize
- silence              - Makes Bitbot be silent for a while (will still respond to commands)
- resume               - Allows Bitbot to resume normal behavior after being silenced
- responders           - Displays a list of all responders with descriptions

### Default Responder Commands

Bitbot comes with some other default responders that provide additional functionality. Responders can be removed from the configuration if you don't want or need some given functionality.

- whois                - Performs a whois command for a given domain
- magic:8ball          - Ask the all mighty 8-ball for an answer to your question
- coin:toss            - Flips a coin
- heroku:app:add       - Add a heroku application
- heroku:app:configure - Configure an existing heroku application
- heroku:app:list      - List heroku applications
- heroku:app:remove    - Remove a heroku application from the list
- heroku:app:deploy    - Deploys a heroku application
- heroku:status        - Check the status of Heroku
- fortune:cookie       - Generates a fortune
- password:generate    - Generate a password
- reminder:create      - Creates a reminder for yourself
- reminder:list        - Lists your upcoming reminders
- reminder:clear       - Clears all of your reminders
- timer:create         - Creates a timer
- weather:forecast     - Fetches a weather forecast for a given location
- weather:conditions   - Displays current conditions for a given location
- weather:moon         - Displays the moon phase information for a given location
- snow:report          - Provides a snow report for a given resort


## Responders

As mentioned above, responders include a wide range of styles, and can be anything from a simple regexp matcher, to something more complex that understands commands, prompting for input etc.

There are three basic aspects of the base responder. Commands, intervals, and events.

This section will be built out more as time goes on and this solidifies more.


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
