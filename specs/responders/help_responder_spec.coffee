describe 'help responder', ->
  responder = require('../../src/responders/help')
  room = {}
  message =
    userId: 123
  bot =
    responders:
      one:
        helpMessage: 'Testing 123'
      two:
        helpMessage: 'Testing 456'

  beforeEach ->
    room.paste = jasmine.createSpy()
    room.speak = jasmine.createSpy()
    room.paste.andReturn(null)
    room.speak.andReturn(null)

  it 'should respond to "what up bot"', ->
    message.body = "what up bot"
    responder.receiveMessage(message, room, bot)
    expect(room.paste).toHaveBeenCalledWith('Testing 123\n\nTesting 456')

  it 'should respond to "help bit bot"', ->
    message.body = "help bit bot"
    responder.receiveMessage(message, room, bot)
    expect(room.paste).toHaveBeenCalledWith('Testing 123\n\nTesting 456')

  it 'should not respond to "help" from itself', ->
    message.userId = 123
    message.body = "help"
    bot.botUserId = 123
    responder.receiveMessage(message, room, bot)
    expect(room.paste).not.toHaveBeenCalled()
