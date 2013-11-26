hue = require('node-hue-api').HueApi

class Responder extends Bitbot.BaseResponder

  hostname: "192.168.1.72"

  responderName: "Hue"
  responderDesc: "I can control your Philips Hue lighting."

  commandPrefix: "hue"

  commands:
    setup:
      desc: "Setup the Hue Bridge (must use the command directly)"

    status:
      desc: "Get the Hue (must use the command directly)"

    on:
      desc: "Turns the lights on"
      examples: ["turn the lights on."]
      intent: "lightson"

    off:
      desc: "Turns the lights on"
      examples: ["turn the lights off."]
      intent: "lightsoff"

    danceParty: {}


  constructor: ->
    super
    @username = false
    @lights = {}
    redis.get 'hue-username', (err, username) =>
      return unless username
      @username = username
      @hue = new HueApi(@hostname, @username)
      @hue.lights (err, response) =>
        @lights[l.name] = l.id for l in response.lights


  setup: (callback) ->
    if @username then return speak: "You've already setup your Hue."

    callback(speak: "Press and release the button on the Hue Bridge (you have 30 seconds).")
    @delay 30 * 1000, =>
      new HueApi().createUser @hostname, null, "bitbot (campfire bot)", (err, username) =>
        unless user then return callback(speak: "Sorry {{&initials}}, I wasn't able to connect with the Hue Bridge.")
        callback(speak: "Okay {{&name}}, we're all setup and ready to go.")
        @username = username
        redis.set('hue-username', username)


  status: (callback) ->
    unless @username then return speak: "Looks like the Hue isn't setup. Use hue:setup to get it fully setup."

    @hue.getFullState (err, config) =>
      unless config then return callback(speak: "Sorry {{&initials}}, I wasn't able to connect to the Hue.")
      @lights = {}
      lights = []
      for id, light of config.lights || []
        continue unless light.state.reachable
        @lights[light.name] = id
        state = light.state
        lights.push("#{light.name} (#{id}) - on: #{state.on} / brightness: #{state.bri} / hue: #{state.hue} / saturation: #{state.sat}")
      callback(paste: lights.join('\n'))


  on: ->
    @hue.setLightState(id, on: true, bri: 10) for name, id of @lights
    speak: "Turning the lights on."


  off: ->
    @hue.setLightState(id, on: false) for name, id of @lights
    speak: "Turning the lights off."


  danceParty: ->
    toggleOn = false
    intervals = []

    @delay 30 * 1000, -> clearTimeout(interval) for interval in intervals

    @hue.setLightState(1, on: true, sat: 255, bri: 255)
    intervals.push(@interval 125, => @hue.setLightState(1, transitiontime: 1, bri: Math.floor(Math.random() * 255)))
    @hue.setLightState(2, on: true, sat: 255, bri: 255)
    intervals.push(@interval 500, => @hue.setLightState(2, transitiontime: 5, hue: Math.floor(Math.random() * 65535)))
    @hue.setLightState(3, on: true, sat: 255, bri: 255, hue: 34515)
    intervals.push(@interval 100, => @hue.setLightState(3, transitiontime: 0, on: toggleOn = !toggleOn))
    @hue.setLightState(4, on: true, sat: 255, bri: 255)
    intervals.push(@interval 250, => @hue.setLightState(4, transitiontime: 1, hue: Math.floor(Math.random() * 65535)))


  # private


  interval: (time, callback) ->
    setInterval(callback, time)



module.exports = new Responder()

