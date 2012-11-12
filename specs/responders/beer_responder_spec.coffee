describe 'beer responder', ->
  beerResponder = require('../../responders/beer')
  room = {}
  message = 
    userId: 123

  beforeEach ->
    room.speak = jasmine.createSpy()
    room.speak.andReturn(null)

  it 'should respond to "beer"', ->
    message.body = "i like beer"
    beerResponder.receiveMessage(message, room, {})
    expect(room.speak).toHaveBeenCalledWith('http://i296.photobucket.com/albums/mm185/robslink1/homer_beer_2401_d.jpg')
    
  it 'should not respond to "beer" from itself', ->
    message.userId = 123
    message.body = "i like beer"
    client = { botUserId: 123}
    beerResponder.receiveMessage(message, room, client)
    expect(room.speak).not.toHaveBeenCalled()
