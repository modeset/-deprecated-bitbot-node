describe 'momma responder', ->
  mommaResponder = require('../../src/responders/momma')
  room = {}
  mommaResponder.responses = [ "http://www.google.com" ]
  message =
    userId: 123

  beforeEach ->
    room.speak = jasmine.createSpy()
    room.speak.andReturn(null)

  it 'should respond to "mom"', ->
    message.body = "call your mom"
    mommaResponder.hear(message, room, {})
    expect(room.speak).toHaveBeenCalledWith(mommaResponder.responses[0])

  it 'should respond to "fat"', ->
    message.body = "your maternal parent is fat today"
    mommaResponder.hear(message, room, {})
    expect(room.speak).toHaveBeenCalledWith(mommaResponder.responses[0])

  it 'should respond to "fat"', ->
    message.body = "hey fatty"
    mommaResponder.hear(message, room, {})
    expect(room.speak).toHaveBeenCalledWith(mommaResponder.responses[0])

  it 'should respond to "phat"', ->
    message.body = "that new Wu-Tang jam is phat"
    mommaResponder.hear(message, room, {})
    expect(room.speak).toHaveBeenCalledWith(mommaResponder.responses[0])

  it 'should respond to "mam"', ->
    message.body = "hey mamma"
    mommaResponder.hear(message, room, {})
    expect(room.speak).toHaveBeenCalledWith(mommaResponder.responses[0])

  it 'should respond to "mother"', ->
    message.body = "check out the mothership over there"
    mommaResponder.hear(message, room, {})
    expect(room.speak).toHaveBeenCalledWith(mommaResponder.responses[0])

  it 'should respond to "mum"', ->
    message.body = "your mum is easy "
    mommaResponder.hear(message, room, {})
    expect(room.speak).toHaveBeenCalledWith(mommaResponder.responses[0])
