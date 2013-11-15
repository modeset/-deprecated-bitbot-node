describe 'coin toss responder', ->
  responder = require('../../src/responders/coin_toss')
  room = {}
  message = 
    userId: 123

  beforeEach ->
    room.speak = jasmine.createSpy()
    room.speak.andReturn(null)

  it 'should respond to "flip a coin"', ->
    message.body = 'flip a coin'
    responder.hear(message, room, {})
    expect([ 'Heads', 'Tails' ]).toContain(room.speak.mostRecentCall.args[0])