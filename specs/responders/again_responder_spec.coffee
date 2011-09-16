describe 'again responder', ->
  beerResponder = require('../../responders/again')
  room = {}
  message = 
    userId: 123

  beforeEach ->
    room.speak = jasmine.createSpy()
    room.speak.andReturn(null)

  it 'should respond to "again" and repeat the previous command', ->
    message.body = "i like beer"
    beerResponder.receiveMessage(message, room, {})
    expect(room.speak).toHaveBeenCalledWith('http://i296.photobucket.com/albums/mm185/robslink1/homer_beer_2401_d.jpg')
    
  it 'should not respond to "beer" from itself', ->
    message.userId = 123
    message.body = "i like beer"
    client = { bitBotId: 123}
    beerResponder.receiveMessage(message, room, client)
    expect(room.speak).not.toHaveBeenCalled()