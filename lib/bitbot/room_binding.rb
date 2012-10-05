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
      puts "Registering #{Bitbot::Responders.available_responders.count} responders"
      @responders = Bitbot::Responders.available_responders.map { |r| r.new(self) }
    end

    def bind_to_room
      @room.listen do |message|
        notify_responders message
      end
    end

    def notify_responders(message)
      @responders.each do |responder|
        if message_from_self?(message) && responder.respond_to?(:receive_own_message)
          responder.receive_own_message(message)
        else
          responder.receive_message message
        end
      end
    end

    def message_from_self?(message)
      message.inspect # This seems to make it more stable
      message.user.id == @bot.bot_user_id
    end

  end

end
