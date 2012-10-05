require 'bitbot/responders/simple_responder'

module Bitbot
  module Responders
    class FuckThatResponder < SimpleResponder
      @responses = ['http://desmond.yfrog.com/Himg644/scaled.php?tn=0&server=644&xsize=640&ysize=640&filename=xopxd.jpg']
      @regex = /fuck that|broke|bull(\s?)shit|fuck(\s?)all|crap|damn it|dammit/
    end
  end
end
