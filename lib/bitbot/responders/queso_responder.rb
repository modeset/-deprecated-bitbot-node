require 'bitbot/responders/simple_responder'

module Bitbot
  module Responders
    class QuesoResponder < SimpleResponder
      @responses = [ 'http://weknowmemes.com/wp-content/uploads/2012/03/in-queso-emergency.jpg' ]
      @regex = /queso/
    end
  end
end
