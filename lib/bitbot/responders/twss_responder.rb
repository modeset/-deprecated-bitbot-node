require 'bitbot/responders/simple_responder'

module Bitbot
  module Responders
    class TWSSResponder < SimpleResponder
      @responses = [ 'TWSS' ]
      @regex = /(?:\b)(big one|in yet|fit that in|will fit|long enough|take long|hard|rough|large|stab at it)(?:\b)/
    end
  end
end
