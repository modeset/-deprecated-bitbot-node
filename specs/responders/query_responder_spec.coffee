describe "db responder", ->
  dbResponder = require '../../responders/query'
  room = {}

  message =
    userId : 123

  beforeEach ->
    room.speak = jasmine.createSpy()
    room.speak.andReturn null

  it "responds to 'db'", ->
    message.body = "so and so db"
    dbResponder.receiveMessage message, room, {}
    expect(room.speak).toHaveBeenCalledWith "http://cdn.memegenerator.net/instances/400x/24281542.jpg"
