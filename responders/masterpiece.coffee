_ = require('underscore')
Shred = require('shred')
shred = new Shred()

exports.helpMessage = "Grab the specials for Masterpiece Deli when you say 'masterpiece specials'"

exports.receiveMessage = (message, room, bot) ->
  if message.body and /masterpiece specials$/.test( message.body )
    shred.get(url: 'https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&num=100&q=https%3A%2F%2Fwww.facebook.com%2Ffeeds%2Fpage.php%3Fid%3D188389694550194%26format%3Drss20').on 200, (response) ->
      entries = JSON.parse(response.content.body).responseData.feed.entries
      todayInDenver = new Date(new Date() - 8 * 3600 * 1000)

      special = _(entries).find (entry) ->
        (new Date(entry.publishedDate).getDate() is todayInDenver.getDate()) and (entry.content.indexOf(':') >= 0)

      if special
        room.speak 'Today\'s Masterpiece Deli special is:'
        room.paste special.content
      else
        room.speak "Sorry, it doesn't look like Masterpiece has posted specials yet today."

