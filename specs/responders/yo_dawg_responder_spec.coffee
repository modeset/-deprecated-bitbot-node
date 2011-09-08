describe 'yo dawg responder', ->
  yoDawgResponder = require('../../responders/yo_dawg')
  room = {}
  message = 
    userId: 123

  beforeEach ->
    room.speak = jasmine.createSpy()
    room.speak.andReturn(null)
    
    # /hello bit bot|yo dawg|sup bit bot|morning bit bot/

  it 'should respond to "yo dawg"', ->
    message.body = "yo dawg"
    yoDawgResponder.receiveMessage(message, room, {})
    expect(yoDawgResponder.responses).toContain(room.speak.mostRecentCall.args[0])
    
  it 'should respond to "hello bit bot"', ->
    message.body = "hello bit bot"
    yoDawgResponder.receiveMessage(message, room, {})
    expect(yoDawgResponder.responses).toContain(room.speak.mostRecentCall.args[0])

  it 'should respond to "hello bitbot"', ->
    message.body = "hello bitbot"
    yoDawgResponder.receiveMessage(message, room, {})
    expect(yoDawgResponder.responses).toContain(room.speak.mostRecentCall.args[0])

    
  it 'should respond to "sup bit bot"', ->
    message.body = "sup bit bot"
    yoDawgResponder.receiveMessage(message, room, {})
    expect(yoDawgResponder.responses).toContain(room.speak.mostRecentCall.args[0])
    
  it 'should respond to "sup bitbot"', ->
    message.body = "sup bitbot"
    yoDawgResponder.receiveMessage(message, room, {})
    expect(yoDawgResponder.responses).toContain(room.speak.mostRecentCall.args[0])
    
  it 'should respond to "morning bit bot"', ->
    message.body = "morning bit bot"
    yoDawgResponder.receiveMessage(message, room, {})
    expect(yoDawgResponder.responses).toContain(room.speak.mostRecentCall.args[0])
    
  it 'should respond to "morning bitbot"', ->
    message.body = "morning bitbot"
    yoDawgResponder.receiveMessage(message, room, {})
    expect(yoDawgResponder.responses).toContain(room.speak.mostRecentCall.args[0])