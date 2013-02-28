	# Prompt is the workhorse of user interactions
    #
    # * No arguments defaults to "Hit enter to continue"
    # * One argument is basically a pause with a custom prompt
    # * Automatically handles invalid choices, only returns a valid selection

	def prompt(string = "Hit enter to continue", *args)
		args.map! {|item| item.to_s.downcase}
		puts string
		if args.length == 0
			gets
			return nil
		else
			unless args.include?(choice = gets.chomp.downcase)
				return prompt((string.include?("Invalid selection.") ? string : "Invalid selection. Please try the options in brackets []\n" + string), *args)
			end
			return choice
		end
	end