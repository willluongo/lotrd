require 'json'
require 'logger'
require_relative 'player.rb'
require_relative 'mob.rb'

class LotRD
	attr_accessor :input, :output

	def puts(*args)
    	@output.puts(*args)    
  	end
 
  	# def gets(*args)
   #  	@input.gets(*args)
  	# end

	def initialize(output = STDOUT, input = STDIN)
		@input = input
		@output = output
		@data = File.join(File.dirname(__FILE__), '..', 'data')
		@forest_monsters = JSON.load(File.open("#{@data}/forest_monsters.json").read)
		@armor_store = JSON.load(File.open("#{@data}/armor.json").read)
		@weapon_store = JSON.load(File.open("#{@data}/weapon.json").read)
		@log = Logger.new("lotrd.log")
		@log.level = Logger::DEBUG
		@play = true
	end

	def rand(limit)
		rnd = Random.new(Time.now.to_i)
		return rnd.rand(limit)
	end

	def get_started
		puts "What is your name?"
		@player = Player.new(gets.chomp)
		@log.debug(@player)
	end

	def get_help
		puts "Hello, #{@player.name}! You look like a strong chap."
		puts "Do you need some directions, or are you ready to get right into it?"
		case prompt("[H]elp me get started\n[N]o, I am ready.", "h", "n")
		when "h"
			display_help
		when "n"
			puts "Ok, let's go!"
		else
			puts "Somehow you tricked my menu!"
		end
	end



	def start
		get_started

		while @play
			main_menu
		end

	end

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

	def display_help
		# TODO: Improve quality of in game help
		puts File.open("#{@data}help.txt").read
		prompt("Got it? Good. Press enter.")
	end


	def main_menu
		system("clear")
		puts @player.status
		menu = <<eom
[F]ight some creatures in the forest
[T]rain for a new level
Go to the [W]eapon Shop
Go to the [A]rmor Shop
[R]est at the inn
E[x]it and save
eom
		case prompt(menu, :f, :t, :w, :a, :r, :x)
		when "x"
			save_and_shutdown
		when "f"
			forest_fight
		when "r"
			visit_inn
		when "a"
			visit_armory
		when "w"
			visit_weaponry
		else
			prompt "Sorry, that isn't implemented yet. Press enter to continue."
		end

	end

	def forest_fight
		@log.debug("Loaded monsters: " + @forest_monsters.to_s)
		foe_level = rand(@player.level) + 1
		@log.debug("Foe level: " + foe_level.to_s)
		@log.debug(foe_choices = @forest_monsters["level_"  + foe_level.to_s])
		foe = foe_choices[rand(foe_choices.length)]
		@log.debug(foe)
		mob = Mob.new(foe["name"], foe["hp"], foe["max_damage"], foe["weapon"])
		@log.debug("Loaded enemy: " + mob.to_s)
		puts "You wander through the forest, looking for a fight..."
		fight(@player, mob)
	end

	def fight(player, mob)
		# TODO: Refactor to make more effective
		fighting = true
		if (rand(@player.initiative) < rand(mob.initiative))
			# Mob goes first!
			puts "But a #{mob.name} finds you first, and he doesn't look happy about it!"
			mob.attack(@player)
			if @player.hp > 0
				case prompt("You have #{@player.hp} hitpoints.\nThe #{mob.name} has #{mob.hp} hitpoints.\n[A]ttack the #{mob.name}!\n[R]un away!", :a, :r)
				when "a"
					@player.attack(mob)
					if mob.alive
						mob.attack(@player)
					end
				when "r"
					#drop out to main menu
				end
			end			
		else
			# Player goes first!
			puts "You come across a #{mob.name}... a perfect target!"
			case prompt("You have #{@player.hp} hitpoints.\nThe #{mob.name} has #{mob.hp} hitpoints.\n[A]ttack the #{mob.name}!\n[R]un away!", :a, :r)
			when "a"
				@player.attack(mob)
				if mob.alive
					mob.attack(@player)
				end
			when "r"
					fighting = false 
					#drop out to main menu
			end
		end
		if mob.alive and @player.hp > 0 and fighting
			fight(@player, mob)
		elsif @player.hp <= 0
			player_death
		elsif !mob.alive
			@player.gain_xp(10)
			@player.gain_gold(10)
			prompt
		else
			#TODO: Check against compared initiatives to see if run succeeds... else free hit for mob!
			if rand(3) == 0
				puts "You barely escape, but your pockets feel lighter... some gold must have fallen out during your escape!"
				@player.lose_gold
			else
				puts "You barely escape from the #{mob.name}!"
			end
			prompt
		end
	end

	def visit_armory
		@log.debug(@armor_store)
		clear
		puts "Welcome to the Armor Shop!"
		item_string = ""
		item_no = 0
		item_list = []
		@armor_store.each do |item|
			item_no = item_no + 1
			item_string = item_string + "\n[#{item_no}] A #{item["name"]}. Armor value #{item["armor_value"]}. Cost: #{item["cost"]} gold."
			item_list.push(item_no)
		end
		select = prompt(item_string + "\n[L]eave the store", *item_list, :l)
		if select == "l"
			# drop out to main menu
		else
			if @player.purchase_armor(select, @armor_store)
				prompt
			else
				prompt
				visit_armory
			end
		end
	end

	def visit_weaponry
		@log.debug(@weapon_store)
		clear
		puts "Welcome to the Weapon Shop!"
		item_string = ""
		item_no = 0
		item_list = []
		@weapon_store.each do |item|
			item_no = item_no + 1
			item_string = item_string + "\n[#{item_no}] A #{item["name"]}. Attack value #{item["attack_value"]}. Cost: #{item["cost"]} gold."
			item_list.push(item_no)
		end
		select = prompt(item_string + "\n[L]eave the store", *item_list, :l)
		if select == "l"
			# drop out to main menu
		else
			if @player.purchase_weapon(select, @weapon_store)
				prompt
			else
				prompt
				visit_weaponry
			end
		end
	end

	def visit_inn
		clear
		puts "Welcome to the Ruby Dragon Inn!"
		case prompt("[S]tay for the night, and recover from today's adventures. (10 Gold)\n[L]eave.", :s, :l)
		when "s"
			if @player.inn(10)
				prompt
			else
				prompt
				visit_inn
			end
		when "l"
			# drop through to main_menu
		end


	end


	def player_death
		prompt
		clear
		puts "Sadly, your quest has ended."
		puts "Because you died."
		case prompt("Would you like to [s]tart again, or [q]uit?",:s,:q)
		when "s"
			game = LotRD.new
			game.start
		when "q"
			save_and_shutdown
		end
	end

	def save_and_shutdown
		# TODO: persist high scores, player if they are alive, etc
		puts "Good bye!"
		@play = false
	end

	def clear
		system("clear")
	end


end