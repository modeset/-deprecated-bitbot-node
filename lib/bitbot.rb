require 'rubygems'
require 'tinder'
require 'eventmachine'
require 'bitbot/room_binding'

Dir.glob(File.join(File.dirname(__FILE__), 'bitbot', 'responders', '*.rb')) do |responder|
  require responder
end

module Bitbot

  class Bot

    def initialize(subdomain = ENV['CAMPFIRE_SUBDOMAIN'], token = ENV['CAMPFIRE_TOKEN'], use_ssl = true)
      @subdomain = subdomain
      @token = token
      @use_ssl = use_ssl
    end

    def run!
      EventMachine::run do
        @campfire.rooms.map { |room| RoomBinding.new(self, room.name) }
      end
    end

    def campfire
      @campfire ||= Tinder::Campfire.new @subdomain, token: @token, ssl: @ssl
    end

    def bot_user_id
      @bot_user_id = campfire.me.id
    end

  end
end

