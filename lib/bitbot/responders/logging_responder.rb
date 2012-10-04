module Bitbot
  module Responders
    class LoggingResponder < BaseResponder
      def receive_message(message)
        puts "#{@room_binding.room.name} heard #{message.inspect}"
      end
    end
  end
end
