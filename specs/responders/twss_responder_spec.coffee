describe 'TWSS responder', ->
  twssResponder = require('../../responders/twss')
  room = {}
  message =
    userId: 1231231

  beforeEach ->
    room.speak = jasmine.createSpy()
    room.speak.andReturn(null)

  it 'should respond to "big one"', ->
    message.body = "that was a big one"
    twssResponder.receiveMessage(message, room, {})
    expect(room.speak).toHaveBeenCalledWith('TWSS')

  it 'should respond to "in yet"', ->
    message.body = "are your changes in yet?"
    twssResponder.receiveMessage(message, room, {})
    expect(room.speak).toHaveBeenCalledWith('TWSS')

  it 'should respond to "fit that in"', ->
    message.body = "i think i can fit that in"
    twssResponder.receiveMessage(message, room, {})
    expect(room.speak).toHaveBeenCalledWith('TWSS')

  it 'should respond to "long enough"', ->
    message.body = "took you long enough"
    twssResponder.receiveMessage(message, room, {})
    expect(room.speak).toHaveBeenCalledWith('TWSS')

  it 'should respond to "hard"', ->
    message.body = "that was too hard"
    twssResponder.receiveMessage(message, room, {})
    expect(room.speak).toHaveBeenCalledWith('TWSS')

  it 'should respond to "rough"', ->
    message.body = "that was rough"
    twssResponder.receiveMessage(message, room, {})
    expect(room.speak).toHaveBeenCalledWith('TWSS')