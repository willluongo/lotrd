require 'spec_helper'

describe LotRD do
	describe "#start" do
		it "Asks the user's name." do 
			output = double('output')
			game = LotRD.new(output)
			output.should_receive(:puts).with('What is your name?')
			game.start
		end
	end
end