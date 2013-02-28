describe 'fuck that responder', ->
  hatersResponder = require('../../src/responders/haters')
  room = {}
  hatersResponder.responses = [ "http://www.google.com" ]
  message = 
    userId: 123

  beforeEach ->
    room.speak = jasmine.createSpy()
    room.speak.andReturn(null)

  it 'should respond to "haters gonna hate"', ->
    message.body = "haters gonna hate"
    hatersResponder.hear(message, room, {})
    expect(room.speak).toHaveBeenCalledWith(hatersResponder.responses[0])
