module Bitbot
  class RoomBinding

    attr_reader :bot,
                :room,
                :thread

    def initialize(bot, room_name)
      @bot = bot
      @room = @bot.campfire.find_room_by_name(room_name)
      register_responders
      @thread = bind_to_room
    end

    private

    def register_responders
      @responders = Bitbot::Responders::BaseResponder.available_responders.map { |r| r.new(self) }
    end

    def bind_to_room
      Thread.new do
        @room.listen do |message|
          puts "#{@room.name}: heard '#{message.body}' from #{message.user.name}"
          notify_responders self, message
        end
        puts "Listening to #{room.name}"
      end
    end

    def notify_responders
      @responders.each do |responder|
        if message_from_self?(message) && responder.respond_to?(:receive_own_message)
          responder.receive_own_message(message)
        else
          responder.receive_message message
        end
      end
    end

    def message_from_self?(message)
      message.user.id == @bot.me.id
    end

  end

end
