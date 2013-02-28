require_relative 'player.rb'
require_relative 'prompt.rb'


# The trainer should:
# Allow the player to spend experience on advancing a level
# Allow the player to learn abilities?

class Trainer
	def initialize player
		@player = player
	end

	def shop
		puts "Doesn't do much yet! :D"
		prompt

	end


end
