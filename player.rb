require './char.rb'
require './weapon.rb'
require './armor.rb'

class Player < Character
	attr_reader :xp, :level
	def initialize(name)
		super(name)
		@weapon = Weapon.new("calloused fists", "punch", 3)
		@armor = Armor.new("sweaty t-shirt", "gets caught in the fold of", 1)
		@gold = 0
		@level = 1
		@xp = 0
	end

	def attack(target)
		rnd = Random.new(Time.now.to_i)
		damage = rnd.rand(@weapon.damage)
		if damage > 0
			puts "You pull out your trusty #{@weapon.name} and #{@weapon.use} the #{target.name}!"
			target.defend(damage)
		else
			puts "You #{@weapon.use} wildly, but to no avail! You don't even come close to hitting the #{target.name}!"
		end

	end

	def defend(damage, attacker, weapon)
		@hp = @hp - damage
		if @hp <= 0 
			die(attacker, weapon)
		else
			puts "The #{attacker} does #{damage} damage!"
		end
	end

	def die(attacker, weapon)
		puts "The #{attacker} stands above you... #{weapon} dripping with your blood... and slowly everything fades to black..."
	end

	def status
		puts "You are level #{@level}, and you have #{@hp} hitpoints, #{@xp} exerience, and #{@gold} gold.\nYou feel like you can take anything on with your #{@weapon.name}, especially while wearing your #{@armor.name}."
	end

	def gain_xp(xp)
		@xp = @xp + xp
		puts "You've gained #{xp} experience!"
	end

	def gain_gold(gold)
		@gold = @gold + gold
		puts "You've gained #{gold} gold!"
	end

end