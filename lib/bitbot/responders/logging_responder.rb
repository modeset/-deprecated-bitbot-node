module Bitbot
  module Responders
    class LoggingResponder < BaseResponder
      def receive_message(message)
        puts "#{@room_binding.room.name} heard #{message.body} from #{message.user.name}"
      end
    end
  end
end
