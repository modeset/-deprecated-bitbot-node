class Responder extends Bitbot.RegexpResponder

  regexp: /(?:\b)(cocaine|drugs)(?:\b)/
  responses: ['http://i1.kym-cdn.com/photos/images/original/000/103/256/i-fucking-love-cocaine.jpg']



module.exports = new Responder()
