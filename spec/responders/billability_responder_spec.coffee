replay = require("replay")

describe 'billability responder', ->

  room = null
  responder = null

  message =
    userId: 123

  beforeEach ->
    process.env.MODESET_METRICS_API_KEY = 'abc123'
    responder = require('../../src/responders/billability')
    room =
      speak: jasmine.createSpy().andReturn(null)

  it 'should have a help message', ->
    expect(responder.helpMessage).toBeDefined()

  describe 'fetching billability stats', ->
    it 'should respond with a summary', ->
      message.body = "what's our billability?"
      runs ->
        responder.respond(message, room, {})
      waitsFor ->
        room.speak.wasCalled
      runs ->
        expect(room.speak).toHaveBeenCalledWith('For the week of 3/25, Someone billed 21 hours and was 52% billable, Someone Else billed 37 hours and was 92% billable and A Third Guy billed 22 hours and was 55% billable.')
