describe 'bummer responder', ->
  bummerResponder = require('../../src/responders/bummer')
  room = {}
  bummerResponder.responses = [ "http://www.google.com" ]
  message =
    userId: 123

  beforeEach ->
    room.speak = jasmine.createSpy()
    room.speak.andReturn(null)

  it 'should respond to "bummer"', ->
    message.body = "bummer"
    bummerResponder.receiveMessage(message, room, {})
    expect(room.speak).toHaveBeenCalledWith(bummerResponder.responses[0])
