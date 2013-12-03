NestApi = require('unofficial-nest-api')

class Responder extends Bitbot.BaseResponder

  settings:
    username: process.env['NEST_USERNAME']
    password: process.env['NEST_PASSWORD']

  responderName: "Nest"
  responderDesc: "I can control your Nest thermostat."

  commandPrefix: "nest"

  commands:
    configure:
      desc: "Setup the Nest connection (must use the command directly)"

    status:
      desc: "Get the Nest status (must use the command directly)"
      examples: ["what's the temperature in here?", "temperature?", "nest status?"]
      intent: "thermostatstatus"

    away:
      desc: "Set the Nest to away mode"
      examples: ["set the thermostat to away.", "go into away mode."]
      intent: "thermostataway"

    home:
      desc: "Set the Nest to home mode"
      examples: ["set the thermostat to home.", "exit away mode."]
      intent: "thermostathome"

    set:
      desc: "Set the temperature"
      examples: ["set the temperature to 72", "adjust the thermostat to 70 degrees"]
      intent: "thermostatset"
      opts:
        temperature: {type: "integer", default: 70}

  templates:
    notConfigured: "Looks like the Nest isn't configured. Use nest:configure to get it setup."
    configureUsername: "Hi {{&initials}}, to get your Nest setup I need the username (or email address) you use to manage it.\n❓ What username do you want to use?"
    configurePassword: "Okay {{&initials}}, I also need the password you use.❓ What's the password?"
    configureSuccess: "Okay {{&name}}, all setup and ready to go."
    configureFailure: "Sorry {{&initials}}, I wasn't able to connect to the Nest."
    modeAway: "Okay {{&initials}}, I've set the thermostats to away mode."
    modeHome: "Okay {{&initials}}, I've turned off away mode."
    setTemp: "Okay {{&name}}, I've set the thermostat to {{&temp}}°."
    status: """
      🍃 Nest Status:

      {{#structures}}
      ☛ {{&name}} - {{&location}}
      {{#devices}}  ∙ {{&name}} - temperature: {{&temp}}° / target: {{&target}}°\n{{/devices}}
      {{/structures}}
      """


  constructor: ->
    @getSettings (err, settings) =>
      @settings = settings if settings
      @initialize()
    super


  configure: (callback, username, password) ->
    if !username
      callback speak: @t('configureUsername'), prompt: (message) =>
        @setSettings(username: @settings.username = message.body)
        @configure(callback, @settings.username)
    else if !password
      callback speak: @t('configurePassword'), prompt: (message) =>
        @setSettings(password: @settings.password = message.body)
        @configure(callback, username, @settings.password)
    else
      callback(speak: @t('configureSuccess'))
      @initialize()


  status: (callback) ->
    unless @nest then return speak: @t('notConfigured')

    @nest.fetchStatus (data) =>
      structures = []

      for id, structure of data.structure
        structureInfo =
          name: structure.name
          location: structure.location
          devices: []
        for deviceId in structure.devices
          device = data.shared[deviceId.replace(/^device\./, '')]
          structureInfo.devices.push
            name: device.name
            temp: @nest.ctof(device.current_temperature)
            target: @nest.ctof(device.target_temperature)
        structures.push(structureInfo)

      callback(paste: @t('status', structures: structures))


  away: ->
    unless @nest then return speak: @t('notConfigured')

    @nest.setAway(true, id) for id in @structureIds
    speak: @t('modeAway')


  home: ->
    unless @nest then return speak: @t('notConfigured')

    @nest.setHome(id) for id in @structureIds
    speak: @t('modeHome')


  set: (temp) ->
    unless @nest then return speak: @t('notConfigured')

    temp = temp.temperature if temp.temperature
    @nest.setTemperature(id, @nest.ftoc(temp)) for id in @deviceIds
    speak: @t('setTemp', temp: temp)


  # private


  initialize: ->
    return unless @settings.username && @settings.password

    NestApi.login @settings.username, @settings.password, (err, data) =>
      if err then return @log(err, 'error')
      @nest = NestApi
      @nest.fetchStatus (data) =>
        @structureIds = @nest.getStructureIds()
        @deviceIds = @nest.getDeviceIds()



module.exports = new Responder()
