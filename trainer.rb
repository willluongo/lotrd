require_relative 'player.rb'
require_relative 'prompt.rb'
require_relative 'player.rb'
require_relative 'shop.rb'


# The trainer should:
# Allow the player to spend experience on advancing a level
# Allow the player to learn abilities?

class Trainer < Shop
	def shop
		puts File.open('./trainer.txt').read
		prompt @menu
	end


	def load_menu
		"I am ready for your [t]raining, master.\nI just stopped in to visit you, master ([l]eave)."
	end

end
