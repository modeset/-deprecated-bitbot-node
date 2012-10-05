require 'bitbot/responders/simple_responder'

module Bitbot
  module Responders
    class NoIdeaResponder < SimpleResponder
      @responses = [  'http://i0.kym-cdn.com/photos/images/newsfeed/000/234/765/b7e.jpg',
                      'http://i1.kym-cdn.com/photos/images/newsfeed/000/234/146/bf8.jpg',
                      'http://i3.kym-cdn.com/photos/images/newsfeed/000/234/767/8d0.jpg',
                      'http://i0.kym-cdn.com/photos/images/newsfeed/000/234/142/196.jpg',
                      'http://chzjustcapshunz.files.wordpress.com/2012/01/funny-captions-i-have-no-idea-what-im-doing.jpg',
                      'http://static.fjcdn.com/comments/I+have+no+idea+what+I+m+doing+thread+_06af9676f192d84f17cf5a5816dc7523.jpg'
              ]
      @@regex = /no idea/
    end
  end
end
