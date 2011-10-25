describe 'fuck that responder', ->
  fuckThatResponder = require('../../responders/fuck_that')
  room = {}
  fuckThatResponder.responseUrl = "http://www.google.com"
  message = 
    userId: 123

  beforeEach ->
    room.speak = jasmine.createSpy()
    room.speak.andReturn(null)

  it 'should respond to "fuck that"', ->
    message.body = "fuck that"
    fuckThatResponder.receiveMessage(message, room, {})
    expect(room.speak).toHaveBeenCalledWith(fuckThatResponder.responseUrl)
    
  it 'should respond to "broke"', ->
    message.body = "broke some shit"
    fuckThatResponder.receiveMessage(message, room, {})
    expect(room.speak).toHaveBeenCalledWith(fuckThatResponder.responseUrl)

  it 'should respond to "bullshit"', ->
    message.body = "this is bullshit"
    fuckThatResponder.receiveMessage(message, room, {})
    expect(room.speak).toHaveBeenCalledWith(fuckThatResponder.responseUrl)
    
  it 'should respond to "damn it"', ->
    message.body = "god damn it"
    fuckThatResponder.receiveMessage(message, room, {})
    expect(room.speak).toHaveBeenCalledWith(fuckThatResponder.responseUrl)
    
  it 'should respond to "crap"', ->
    message.body = "what's this crap?"
    fuckThatResponder.receiveMessage(message, room, {})
    expect(room.speak).toHaveBeenCalledWith(fuckThatResponder.responseUrl)
    
  it 'should respond to "dammit"', ->
    message.body = "dammit all"
    fuckThatResponder.receiveMessage(message, room, {})
    expect(room.speak).toHaveBeenCalledWith(fuckThatResponder.responseUrl)
    
  it 'should respond to "bull shit"', ->
    message.body = "this is some serious bull shit"
    fuckThatResponder.receiveMessage(message, room, {})
    expect(room.speak).toHaveBeenCalledWith(fuckThatResponder.responseUrl)

  it 'should respond to "fuck all"', ->
    message.body = "fuck all"
    fuckThatResponder.receiveMessage(message, room, {})
    expect(room.speak).toHaveBeenCalledWith(fuckThatResponder.responseUrl)

  it 'should respond to "fuckall"', ->
    message.body = "fuckall"
    fuckThatResponder.receiveMessage(message, room, {})
    expect(room.speak).toHaveBeenCalledWith(fuckThatResponder.responseUrl)