require 'spec_helper'

describe Bitbot::Bot do

  let(:bot) { Bitbot::Bot.new }

  it 'responds to run!' do
    bot.should respond_to(:run!)
  end

end
