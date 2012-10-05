require 'bitbot/responders/simple_responder'

module Bitbot
  module Responders
    class HatersResponder < SimpleResponder
      @responses = [ 'http://www.lolbrary.com/lolpics/903/haters-gonna-hate-unicorn-bike-edition-6903.jpg',
                      'http://www.hatersgoingtohate.com/wp-content/uploads/2010/06/haters-gonna-hate-cat.jpg',
                      'http://i671.photobucket.com/albums/vv78/Sinsei55/HatersGonnaHatePanda.jpg',
                      'http://legacy-cdn.smosh.com/smosh-pit/062010/haters-6.jpg',
                      'http://legacy-cdn.smosh.com/smosh-pit/062010/haters-2.jpg',
                      'http://legacy-cdn.smosh.com/smosh-pit/062010/haters-8.jpg',
                      'http://s3.amazonaws.com/kym-assets/photos/images/newsfeed/000/085/977/HATERS.jpg',
                      'http://s3.amazonaws.com/kym-assets/photos/images/newsfeed/000/055/267/PWHHGH.jpg' ]
      @regex = /hater/
    end
  end
end
