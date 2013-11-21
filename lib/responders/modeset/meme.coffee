request = require('request')

class Responder extends Bitbot.RegexpResponder

  regexp: /(?:\b)(meme)(?:\b)/
  url: "http://api.automeme.net/text.json?lines=1"

  randomResponse: (callback) ->
    request @url, (err, response, body) =>
      try callback(speak: JSON.parse(body)[0])
      catch e
        @log(e.message, 'error')


module.exports = new Responder()
