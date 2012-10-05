module Bitbot
  module Responders

    class << self
      attr_accessor :available_responders
    end
    @available_responders = []

    class BaseResponder

      class << self
        def inherited(base)
          Bitbot::Responders.available_responders << base
        end
      end


      def initialize(room_binding)
        @room_binding = room_binding
      end

      def receive_message(message)
        raise 'Subclass must implement receive_message(msg)'
      end

      def speak(body)
        @room_binding.room.speak body
      end

    end
  end
end
