replay = require("replay")

describe 'opensnow responder', ->

  room = null
  responder = null

  message =
    userId: 123

  beforeEach ->
    process.env.OPENSNOW_API_KEY = 'mykey'
    responder = require('../../src/responders/opensnow')
    room =
      speak: jasmine.createSpy().andReturn(null)

  it 'should have a help message', ->
    expect(responder.helpMessage).toBeDefined()

  describe 'fetching a forecast for a nonexistent resort', ->
    it 'should respond with a error message', ->
      message.body = "powder for nowhere"
      runs ->
        responder.receiveMessage(message, room, {})
      waitsFor ->
        room.speak.wasCalled
      runs ->
        expect(room.speak).toHaveBeenCalledWith('Sorry, I couldn\'t find that resort in Colorado')

  describe 'fetching a forecast for a resort', ->
    it 'should respond with a forecast summary', ->
      message.body = "powder for beaver creek"
      runs ->
        responder.receiveMessage(message, room, {})
      waitsFor ->
        room.speak.wasCalled
      runs ->
        line = "During the day, the forecast is 'Chance Snow' with a high of 11 and 0-1\" of accumulation. Tonight, the forecast is 'Chance Snow' with a low of 0 and 0-1\" of accumulation. Tomorrow, the forecast is \'Chance Snow\' with a high of 13 and 0\" of accumulation."
        expect(room.speak).toHaveBeenCalledWith(line)
