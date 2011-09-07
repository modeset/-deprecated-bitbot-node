#!/bin/sh
# Compile it up
node_modules/.bin/coffee -c *.coffee
node_modules/.bin/coffee -c responders/*.coffee
# Run specs
node_modules/jasmine-node/bin/jasmine-node --coffee specs