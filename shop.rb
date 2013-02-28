require_relative 'player.rb'
require_relative 'prompt.rb'
require_relative 'player.rb'

# The trainer should:
# Allow the player to spend experience on advancing a level
# Allow the player to learn abilities?

class Shop
	def initialize player
		@player = player
		@menu = load_menu
		system("clear")

	end

	def shop
		raise NotImplementedError, "You need to make sure you implement the #{__method__} method"
	end

	def load_menu
		raise NotImplementedError, "You need to make sure you implement the #{__method__} method"
	end

end
