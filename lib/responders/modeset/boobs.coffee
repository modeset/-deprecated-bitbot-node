class Responder extends Bitbot.RegexpResponder

  regexp: /(?:\b)breasts|mammaries|boobs(?:\b)/
  responses: [
    'http://d104xtrw2rzoau.cloudfront.net/wp-content/uploads/2013/04/katy-perry2.gif'
    'http://jamesrayneau.files.wordpress.com/2013/02/katy-perry-funny-elmo.gif'
  ]

module.exports = new Responder()
