require 'bitbot/responders/simple_responder'

module Bitbot
  module Responders
    class HelloResponder < SimpleResponder
      @responses = [ 'http://i1.kym-cdn.com/photos/images/newsfeed/000/217/040/48ACD.png' ]
      @regex = /hello/
    end
  end
end
