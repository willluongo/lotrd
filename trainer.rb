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
		case prompt @menu
		when "t"
			train
		when "l"
			puts "Goodbye, my student. Stop by when you are ready to advance in the ways of Rubai."
		else
			puts "Not implemented yet!"
		end
		prompt
	end


	def load_menu
		"I am ready for your [t]raining, master.\nI just stopped in to visit you, master ([l]eave)."
	end

	def train
		if @player.xp >= 100
			puts "I see you are ready to advance...\n\nHours later you leave... tired, but a level higher."
			@player.level_up
		else
			puts "I am sorry, my child. You are not yet ready. Come back when you have at least #{100 - @player.xp} more experience."
		end
	end


end
