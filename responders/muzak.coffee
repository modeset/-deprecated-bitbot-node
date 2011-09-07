wwwdude = require("wwwdude")

json_client = wwwdude.createClient({
    contentParser: wwwdude.parsers.json
})

exports.helpMessage = "recommend you some music when you say 'find me some <mood> tunes' or 'find me some <style> music'"

exports.receiveMessage = (message, room) ->
  exports.respondToTunes(message,room)
  exports.respondToMusic(message,room)

exports.respondToTunes = (message, room) ->
  msg_regex = /^find me some (.+) tunes/
  if message.body and msg_regex.test( message.body )
    regex_results = msg_regex.exec(message.body)
    mood = regex_results[1]
    request_url = "http://developer.echonest.com/api/v4/song/search?api_key=#{process.env.ECHONEST_API_KEY}&format=json&results=1&mood=#{mood}&sort=artist_hotttnesss-desc"
    json_client.get(request_url).on('success', (data, response) ->
      if(data.response.songs.length > 0)
        song = data.response.songs[0]
        room.speak("try #{song.title} by #{song.artist_name}")
      else
        room.speak "sorry, couldn't find any #{mood} tunes for you"
    )

exports.respondToMusic = (message, room) ->
  msg_regex = /^find me some (.+) music/
  if message.body and msg_regex.test( message.body )
    regex_results = msg_regex.exec(message.body)
    style = regex_results[1]
    request_url = "http://developer.echonest.com/api/v4/song/search?api_key=#{process.env.ECHONEST_API_KEY}&format=json&results=1&style=#{style}&sort=artist_hotttnesss-desc"
    json_client.get(request_url).on('success', (data, response) ->
      if(data.response.songs.length > 0)
        song = data.response.songs[0]
        room.speak("try #{song.title} by #{song.artist_name}")
      else
        room.speak "sorry, couldn't find any #{style} music for you"
    )