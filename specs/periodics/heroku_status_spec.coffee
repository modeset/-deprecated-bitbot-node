replay = require("replay")

describe 'heroku status periodic', ->

  room = null
  periodic = null

  beforeEach ->
    periodic = require('../../src/periodics/heroku_status')
    room =
      speak: jasmine.createSpy().andReturn(null)
    periodic.bind room, false

  describe 'checking status normally', ->
    it 'doesn\'t notify when everything is kosher', ->
      runs ->
        periodic.checkOnStatus()
      runs ->
        expect(room.speak).not.toHaveBeenCalled()

  describe 'when heroku reports downtime', ->
    beforeEach ->
      periodic.doesHerokuHaveIssues = (cb) -> cb.call(@, true)
      periodic.notifiedOfTrouble = false

    it 'should notify with a error message', ->
      runs      -> periodic.checkOnStatus()
      waitsFor  -> room.speak.wasCalled
      runs      -> expect(room.speak).toHaveBeenCalledWith('Heroku is reporting issues. Check http://status.heroku.com/ for details')

    it 'should not notify when it has already done so', ->
      runs      -> periodic.checkOnStatus()
      runs      -> periodic.checkOnStatus()
      runs      -> expect(room.speak.callCount).toBe(1)

