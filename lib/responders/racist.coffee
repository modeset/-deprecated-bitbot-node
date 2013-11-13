responder = new Bitbot.SimpleResponder(/black|white|asian|chocolate/, ["http://i2.kym-cdn.com/photos/images/newsfeed/000/157/122/f.gif"])
exports.main = (message = m, callback = exit) -> responder.main(message, callback)
