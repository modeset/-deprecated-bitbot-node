require 'bitbot/responders/simple_responder'

module Bitbot
  module Responders
    class ThanksResponder < SimpleResponder
      @responses = [ 'NP',
                      'any time!',
                      'you got it',
                      'you\'re welcome' ]

      @regex = /thank/
    end
  end
end
