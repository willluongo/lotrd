	# Prompt is the workhorse of user interactions
    #
    # * No arguments defaults to "Hit enter to continue"
    # * One argument is basically a pause with a custom prompt
    # * Automatically handles invalid choices, only returns a valid selection

	def prompt(string = "Hit enter to continue")
		puts string
		choices = extractor string

		unless choices.include?(choice = gets.chomp.downcase)
			return prompt((string.include?("Invalid selection.") ? string : "Invalid selection. Please try the options in brackets []\n" + string))
		else
			return choice
		end
	end

	def extractor(string)
		bits = []
		string.split("]").each {|bit| bits.push bit.split("[")[0]; bits.push bit.split("[")[1] }
		choices = []
		bits.each_with_index do |bit, index|
			unless index % 2 == 0
				choices.push bit.to_s.downcase
			end
		end
		return choices
	end