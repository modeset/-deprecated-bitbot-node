fs = require 'fs'
{exec} = require 'child_process'

task 'spec', 'run tests', (options) ->
  exec 'node_modules/jasmine-node/bin/jasmine-node specs --coffee', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr