require 'spec_helper'

describe LotRD do
	describe "#start" do
		before(:all) do
			@game = LotRD.new
		end
		it "Asks the user's name." do 
			fake_stdin("Will") do 
				output = double('output').as_null_object
				@game.output = output
				@game.get_started
				output.should_receive(:puts).with('What is your name?')
			end
		end
		it "Asks if user needs help." do
			fake_stdin("n") do
				output = double('output').as_null_object
				@game.get_help
				output.should_receive(:puts).with('Do you need some directions, or are you ready to get right into it?')
			end
		end
	end
end