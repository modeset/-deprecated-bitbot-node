require 'rubygems'
require 'tinder'
require 'eventmachine'
require 'bitbot/room_binding'

Dir.glob(File.join(File.dirname(__FILE__), 'bitbot', 'responders', '*.rb')) do |responder|
  require responder
end

module Bitbot

  class Bot

    attr_accessor :campfire

    def initialize(subdomain = ENV['CAMPFIRE_SUBDOMAIN'], token = ENV['CAMPFIRE_TOKEN'], ssl = true)
      @campfire = Tinder::Campfire.new subdomain, token: token, ssl: ssl
    end

    def run!
      EventMachine::run do
        @campfire.rooms.map { |room| RoomBinding.new(self, room.name) }
      end
    end

  end
end

