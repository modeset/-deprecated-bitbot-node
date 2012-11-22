Shred = require("shred")

class HerokuStatusPeriodic

  constructor: ->
    @shred = new Shred()

  bind: (room) =>
    @room = room
    setInterval @checkStatus, 5 * 60 * 1000

  checkStatus: =>
    console.log 'Checking for Heroku status updates'
    @shred.get(url: 'https://status.heroku.com/api/v3/current-status').on 200, (response) =>
      if response.content.data.issues.length > 0
        @room.speak 'Heroku is reporting issues. Check http://status.heroku.com/ for details'

module.exports = new HerokuStatusPeriodic()
