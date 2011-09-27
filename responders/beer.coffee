exports = 
	name: "Beer"
	receiveMessage: (message, room, client) ->
  	beer_regex = /beer/
		room.speak "http://i296.photobucket.com/albums/mm185/robslink1/homer_beer_2401_d.jpg" if message.userId != client.bitBotId and message.body and message.body.match(beer_regex)