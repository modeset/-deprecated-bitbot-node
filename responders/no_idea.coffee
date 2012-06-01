SimpleResponder = require './simple_responder'

responses = [ 'http://i0.kym-cdn.com/photos/images/newsfeed/000/234/765/b7e.jpg',
              'http://i1.kym-cdn.com/photos/images/newsfeed/000/234/146/bf8.jpg',
              'http://i3.kym-cdn.com/photos/images/newsfeed/000/234/767/8d0.jpg',
              'http://i0.kym-cdn.com/photos/images/newsfeed/000/234/142/196.jpg'
              ]
regex     = /no idea/
noIdeaResponder    = new SimpleResponder(regex, responses)

module.exports = noIdeaResponder
