class Responder extends Bitbot.RegexpResponder

  regexp: /(?:\b)(bummer)(?:\b)/
  responses: ['http://static.happyplace.com/assets/images/2011/10/4eaec154866a8.jpg']



module.exports = new Responder()
