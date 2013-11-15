class Responder extends Bitbot.RegexpResponder

  regexp: /beer/
  responses: ['http://i296.photobucket.com/albums/mm185/robslink1/homer_beer_2401_d.jpg']

module.exports = new Responder()
