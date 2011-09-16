exports.responseUrl = "http://desmond.yfrog.com/Himg644/scaled.php?tn=0&server=644&xsize=640&ysize=640&filename=xopxd.jpg"

exports.receiveMessage = (message, room, client) ->
  fuck_that_regex = /fuck that|broke|bull(\s?)shit|fuck(\s?)all|crap|damn it|dammit/
  room.speak exports.responseUrl if message.userId != client.bitBotId and message.body and message.body.match(fuck_that_regex)
