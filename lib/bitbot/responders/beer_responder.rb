require 'bitbot/responders/simple_responder'

module Bitbot
  module Responders
    class BeerResponder < SimpleResponder
      @responses = ['http://i296.photobucket.com/albums/mm185/robslink1/homer_beer_2401_d.jpg']
      @regex = /beer/
    end
  end
end
