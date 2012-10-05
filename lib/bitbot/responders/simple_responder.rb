module Bitbot
  module Responders
    class SimpleResponder < BaseResponder

      class << self
        attr_accessor :responses,
                      :regex
      end

      def receive_message(message)
        return unless self.class.responses && !self.class.responses.empty? && self.class.regex
        puts "Matching '#{message.body}' against #{self.class.regex.to_s}"
        speak self.class.responses.sample if self.class.regex.match(message.body)
      end
    end

  end
end
