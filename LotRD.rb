require 'json'
require 'logger'
require_relative 'player.rb'
require_relative 'mob.rb'

class LotRD
	def initialize()
		@forest_monsters = JSON.load(File.open('./forest_monsters.json').read)
		@log = Logger.new("lotrd.log")
		@log.level = Logger::DEBUG
	end

	def rand(limit)
		rnd = Random.new(Time.now.to_i)
		return rnd.rand(limit)
	end


	def start
		puts "What is your name?"
		@player = Player.new(gets.chomp)
		@log.debug(@player)
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
		main_menu

	end

	def prompt(string, *args)
		args.map! {|item| item.to_s.downcase}
		puts string
		if args.length == 0
			gets
			return nil
		else
			unless args.include?(choice = gets.chomp.downcase)
				return prompt("Invalid selection. Please try the options in brackets []\n" + string, *args)
			end
			return choice
		end
	end

	def display_help
		puts "This is the help!"
		prompt("[1] Exit\n[2] Replay \n[DELETE] Delete your character.", 1, 2, "DELETE")
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
		else
			prompt "Sorry, that isn't implemented yet. Press any key to continue."
			main_menu

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
					main_menu
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
				main_menu
			end
		end
		if mob.alive and @player.hp > 0 
			fight(@player, mob)
		elsif @player.hp <= 0
			player_death
		else
			@player.gain_xp(10)
			@player.gain_gold(10)
			prompt("Press any key to continue.")
			main_menu
		end
	end

	def player_death
		prompt "Press any key to continue."
		system("clear")
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
	end


end

if __FILE__ == $0
	game = LotRD.new()
	game.start
end