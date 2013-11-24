request = require('request')

class Responder extends Bitbot.RegexpResponder

  url: "http://api.automeme.net/text.json?lines=1"

  regexp: /(?:\b)(meme)(?:\b)/


  randomResponse: (callback) ->
    request @url, (err, response, body) =>
      try response = JSON.parse(body)[0]
      callback(speak: response)



module.exports = new Responder()
