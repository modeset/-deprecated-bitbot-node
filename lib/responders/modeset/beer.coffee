class Responder extends Bitbot.RegexpResponder

  regexp: /(?:\b)beer(?:\b)/
  responses: [
    'http://i296.photobucket.com/albums/mm185/robslink1/homer_beer_2401_d.jpg'
    "Mmmmm... 🍺"
  ]



module.exports = new Responder()
