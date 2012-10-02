module Bitbot
  module Responders
    class BaseResponder

      @available_responders = []

      class << self
        attr_accessor :available_responders
      end

      def self.inherited(base)
        @available_responders << base
      end

      def initialize(room_binding)
        @room_binding = room_binding
      end

      def receive_message(message)
        raise 'Subclass must implement receive_message(msg)'
      end

    end
  end
end
