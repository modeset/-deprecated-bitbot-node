responder = new Bitbot.SimpleResponder(/boobs/, ["http://d104xtrw2rzoau.cloudfront.net/wp-content/uploads/2013/04/katy-perry2.gif"])
exports.main = (message = m, callback = exit) -> responder.main(message, callback)
