_ = require('underscore')
Shred = require('shred')
shred = new Shred()

exports.helpMessage = "grab a snow report when you say 'snow for <resort>'"

exports.receiveMessage = (message, room, bot) ->
  if message.body and /^snow for (.+)/.test( message.body )
    placename = /^snow for (.+)/.exec(message.body)[1].toLowerCase()
    shred.get(url: 'https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&num=100&q=http://www.onthesnow.com/colorado/snow.rss').on 200, (response) ->
      console.log response.content.data
      entries = response.content.data.responseData.feed.entries

      result = _(entries).find (entry) ->
        entry.title.toLowerCase().indexOf(placename) >= 0

      if result
        room.speak "#{result.title}: #{result.content}"
      else
        room.speak 'Sorry, couldn\'t find that resort in Colorado'

