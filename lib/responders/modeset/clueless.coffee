class Responder extends Bitbot.RegexpResponder

  regexp: /no idea|clueless/
  responses: [
    'http://i0.kym-cdn.com/photos/images/newsfeed/000/234/765/b7e.jpg',
    'http://i1.kym-cdn.com/photos/images/newsfeed/000/234/146/bf8.jpg',
    'http://i3.kym-cdn.com/photos/images/newsfeed/000/234/767/8d0.jpg',
    'http://i0.kym-cdn.com/photos/images/newsfeed/000/234/142/196.jpg',
    'http://www.constructionknowledge.net/blog/wp-content/uploads/2012/12/Donkey_blueprints.jpg',
    'http://marco-pivetta.com/proxy-pattern-in-php/assets/img/i-have-no-idea-what-i-m-doing.jpg',
    'https://i.chzbgr.com/maxW500/6443970560/h5D3CE08F/'
  ]

module.exports = new Responder()
