class Responder extends Bitbot.RegexpResponder

  regexp: /(?:\b)(big one|in yet|fit that in|long enough|take long|hard|rough|large|stab at it)(?:\b)/
  responses: ['TWSS']



module.exports = new Responder()
