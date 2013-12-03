HueApi = require('node-hue-api').HueApi

class Responder extends Bitbot.BaseResponder

  responderName: "Hue"
  responderDesc: "I can control your Philips Hue lighting."

  commandPrefix: "hue"

  commands:
    configure:
      desc: "Setup the Hue Bridge (must use the command directly)"

    status:
      desc: "Get the Hue Status (must use the command directly)"

    on:
      desc: "Turns the lights on"
      examples: ["turn the lights on."]
      intent: "lightson"

    off:
      desc: "Turns the lights on"
      examples: ["turn the lights off."]
      intent: "lightsoff"

  templates:
    notConfigured: "Looks like the Hue isn't configured. Use hue:configure to get it setup."
    configureHostname: "Hi {{&initials}}, to get your Philips Hue setup I need the hostname (or IP) of your Hue Bridge. You should be able to get this at: http://www.meethue.com/api/nupnp\n❓ What hostname do you want to use?"
    configureUsername: "Okay {{&initials}}, I need access to the Bridge. To do this, you'll need to press and release the button on the Hue Bridge (you have 30 seconds)."
    configureSuccess: "Okay {{&name}}, all setup and ready to go."
    configureFailure: "Sorry {{&initials}}, I wasn't able to connect with the Hue Bridge."
    lightsOn: "Turning the lights on."
    lightsOff: "Turning the lights off."
    statusNotConnected: "Sorry {{&initials}}, I wasn't able to connect to the Hue."
    status: """
      💡 Philips Hue Status:

      {{#lights}}{{&id}}: {{&name}} - reachable: {{&state.reachable}} / on: {{&state.on}} / brightness: {{&state.bri}} / hue: {{&state.hue}} / saturation: {{&state.sat}}\n{{/lights}}
      """


  constructor: ->
    @getSettings (err, @settings = {}) => @initialize()
    super


  configure: (callback, hostname, username) ->
    if !hostname
      callback speak: @t('configureHostname'), prompt: (message) =>
        @setSettings(hostname: @settings.hostname = message.body)
        @configure(callback, @settings.hostname)
    else if !username
      callback speak: @t('configureUsername')
      @delay 30 * 1000, =>
        new HueApi().createUser @settings.hostname, null, 'bitbot (campfire bot)', (err, username) =>
          unless username then return callback(speak: @t('configureFailure'))
          @setSettings(username: @settings.hostname = username)
          @configure(callback, hostname, @settings.hostname)
    else
      callback(speak: @t('configureSuccess'))
      @initialize()


  status: (callback) ->
    unless @hue then return speak: @t('notConfigured')

    @hue.getFullState (err, config) =>
      unless config then return callback(speak: @t('statusNotConnected'))
      lights = for id, light of config.lights || []
        _(light).extend(id: id)
      callback(paste: @t('status', lights: lights))


  on: ->
    unless @hue then return speak: @t('notConfigured')

    @hue.setLightState(id, on: true, bri: 10) for name, id of @lights
    speak: @t('lightsOn')


  off: ->
    unless @hue then return speak: @t('notConfigured')

    @hue.setLightState(id, on: false) for name, id of @lights
    speak: @t('lightsOff')


  # private


  initialize: ->
    return unless @settings.hostname && @settings.username
    @hue = new HueApi(@settings.hostname, @settings.username)
    @lights = {}
    @hue.lights (err, response) =>
      return unless response
      @lights[l.name] = l.id for l in response.lights


#  danceParty: ->
#    toggleOn = false
#    intervals = []
#
#    @delay 30 * 1000, -> clearTimeout(interval) for interval in intervals
#
#    @hue.setLightState(1, on: true, sat: 255, bri: 255)
#    intervals.push(@interval 125, => @hue.setLightState(1, transitiontime: 1, bri: Math.floor(Math.random() * 255)))
#    @hue.setLightState(2, on: true, sat: 255, bri: 255)
#    intervals.push(@interval 500, => @hue.setLightState(2, transitiontime: 5, hue: Math.floor(Math.random() * 65535)))
#    @hue.setLightState(3, on: true, sat: 255, bri: 255, hue: 34515)
#    intervals.push(@interval 100, => @hue.setLightState(3, transitiontime: 0, on: toggleOn = !toggleOn))
#    @hue.setLightState(4, on: true, sat: 255, bri: 255)
#    intervals.push(@interval 250, => @hue.setLightState(4, transitiontime: 1, hue: Math.floor(Math.random() * 65535)))
#
#
#  interval: (time, callback) ->
#    setInterval(callback, time)



module.exports = new Responder()

