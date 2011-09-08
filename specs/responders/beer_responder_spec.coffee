describe 'beer responder', ->
  beerResponder = require('../../responders/beer')
  room = {}
  message = {}

  beforeEach ->
    room.speak = jasmine.createSpy()
    room.speak.andReturn(null)

  it 'should respond to "beer"', ->
    message.body = "i like beer"
    beerResponder.receiveMessage(message, room, null)
    expect(room.speak).toHaveBeenCalledWith('http://i296.photobucket.com/albums/mm185/robslink1/homer_beer_2401_d.jpg')