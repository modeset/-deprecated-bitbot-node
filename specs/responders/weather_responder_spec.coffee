replay = require("replay")

describe 'weather responder', ->

  room = null
  responder = null

  message =
    userId: 123

  beforeEach ->
    process.env.WUNDERGROUND_API_KEY = 'mykey'
    responder = require('../../src/responders/weather')
    room =
      speak: jasmine.createSpy().andReturn(null)

  it 'should have a help message', ->
    expect(responder.helpMessage).toBeDefined()

  describe 'fetching weather for a nonexistent location', ->
    it 'should respond with a error message', ->
      message.body = "weather for blablabla"
      runs ->
        responder.respond(message, room, {})
      waitsFor ->
        room.speak.wasCalled
      runs ->
        expect(room.speak).toHaveBeenCalledWith('Sorry, I couldn\'t find that location')

  describe 'fetching a forecast', ->
    it 'should respond with a forecast summary', ->
      message.body = "forecast for denver"
      runs ->
        responder.respond(message, room, {})
      waitsFor ->
        room.speak.wasCalled
      runs ->
        expect(room.speak).toHaveBeenCalledWith('Partly cloudy. High of 36F. Winds less than 5 mph.')

  describe 'fetching current conditions', ->
    it 'should respond with a conditions summary', ->
      message.body = "weather for denver"
      runs ->
        responder.respond(message, room, {})
      waitsFor ->
        room.speak.wasCalled
      runs ->
        expect(room.speak).toHaveBeenCalledWith('Current weather in Denver, CO is scattered clouds, temperature is 31.6 F (-0.2 C), winds from the west at 2.0 mph gusting to 12.0 mph, 35% relative humidity')
