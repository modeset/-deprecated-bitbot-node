describe 'shut up responder', ->

  room      = null
  responder = null
  bot       = null
  message   = null

  beforeEach ->
    responder = require('../../src/responders/shut_up')
    message =
      userId: 123
    room =
      speak: jasmine.createSpy().andReturn(null)
    bot =
      earmuffs: jasmine.createSpy().andReturn(null)

  it 'should have a help message', ->
    expect(responder.helpMessage).toBeDefined()

  describe 'silencing itself', ->
    beforeEach ->
      message.body = "shut up"

    it 'responds with an apology', ->
      runs ->
        responder.respond(message, room, bot)
      waitsFor ->
        room.speak.wasCalled
      runs ->
        expect(room.speak).toHaveBeenCalledWith('Sorry. I\'ll be quiet for the next 5 minutes unless you speak directly to me.')

    it 'earmuffs the relevant room', ->
      runs ->
        responder.respond(message, room, bot)
      waitsFor ->
        room.speak.wasCalled
      runs ->
        expect(bot.earmuffs).toHaveBeenCalledWith(room)
