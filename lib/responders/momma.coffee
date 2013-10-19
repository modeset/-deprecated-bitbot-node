SimpleResponder = require '../simple_responder'

responses = [ 'http://i.imgur.com/o0Vbs.jpg',
              'http://25.media.tumblr.com/tumblr_lmm9rn8LwA1qzxfy9o1_400.jpg',
              'http://24.media.tumblr.com/tumblr_m43j0gWVR61rvmzlbo1_400.gif',
              'http://www.mopo.ca/wp-content/uploads/2012/05/dear-nasa.jpg'
              ]
regex           = /\^mom|mom$| mom |mamma|momma|mum|fat|phat|mother/
module.exports  = new SimpleResponder(regex, responses)
