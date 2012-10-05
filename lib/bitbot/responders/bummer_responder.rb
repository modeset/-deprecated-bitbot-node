require 'bitbot/responders/simple_responder'

module Bitbot
  module Responders
    class BummerResponder < SimpleResponder
      @responses = [ 'http://static.happyplace.com/assets/images/2011/10/4eaec154866a8.jpg' ]
      @regex = /bummer/
    end
  end
end
