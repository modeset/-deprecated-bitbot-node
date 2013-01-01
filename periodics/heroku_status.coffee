request = require('request')

class HerokuStatusPeriodic

  constructor: ->
    @rooms = []
    @notifiedOfTrouble = false

  bind: (room, setTimer = true) =>
    @rooms.push room
    setInterval(@checkOnStatus, 5 * 60 * 1000) if setTimer

  checkOnStatus: =>
    @doesHerokuHaveIssues (isInTrouble) =>
      if isInTrouble
        unless @notifiedOfTrouble
          room.speak 'Heroku is reporting issues. Check http://status.heroku.com/ for details' for room in @rooms
        @notifiedOfTrouble = true
      else
        @notifiedOfTrouble = false

  doesHerokuHaveIssues: (callback) =>
    request 'https://status.heroku.com/api/v3/current-status', (error, response, body) =>
      callback.call @, (JSON.parse(body).issues.length > 0)

module.exports = new HerokuStatusPeriodic()
