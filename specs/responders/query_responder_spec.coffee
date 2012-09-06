describe "db responder", ->
  dbResponder = require '../../responders/query'
  room = {}

  message =
    userId : 123

  url = "http://cdn.memegenerator.net/instances/400x/24281542.jpg"

  beforeEach ->
    room.speak = jasmine.createSpy()
    room.speak.andReturn null

  it "responds to 'db'", ->
    message.body = "so and so db"
    dbResponder.receiveMessage message, room, {}
    expect(room.speak).toHaveBeenCalledWith url

  it "does not respond to inline db", ->
    message.body = "so and so feedback"
    dbResponder.receiveMessage message, room , {}
    expect(room.speak).not.toHaveBeenCalledWith url

  it "responds to database", ->
    message.body = "so and so database"
    dbResponder.receiveMessage message, room, {}
    expect(room.speak).toHaveBeenCalledWith url
