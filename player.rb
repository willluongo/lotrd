require './char.rb'
require './weapon.rb'
require './armor.rb'

class Player < Character
	attr_reader :xp, :level, :gold
	def initialize(name)
		super(name)
		@weapon = Weapon.new("calloused fists", "punch", 3, 0)
		@armor = Armor.new("sweaty t-shirt", "gets caught in the fold of", 1, 10)
		@gold = 0
		@level = 1
		@xp = 0
		@hp_max = @hp
	end

	def attack(target)
		# TODO add level modifier
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
		#TODO implement armor values
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

	def lose_gold(gold = @gold / 4)
		@gold = @gold - gold
	end

	def purchase_armor(select, store)
		old_armor = @armor
		armor = store[select.to_i-1]
		if @gold >= armor["cost"]
			@armor = Armor.new(armor["name"], armor["use"], armor["armor_value"], armor["cost"])
			@gold = @gold - armor["cost"] + old_armor.cost
			puts "Sold! You are now the proud owner of #{@armor.name}! I even gave you #{old_armor.cost / 2} for that old #{old_armor.name}!"
			return true
		else
			puts "I am sorry, you don't have enough gold, and I don't do charity!"
			return false
		end
	end

	def purchase_weapon(select, store)
		old_weapon = @weapon
		weapon = store[select.to_i-1]
		if @gold >= weapon["cost"]
			@weapon = Weapon.new(weapon["name"], weapon["use"], weapon["attack_value"], weapon["cost"])
			@gold = @gold - weapon["cost"] + old_weapon.cost
			puts "Sold! You are now the proud owner of #{@weapon.name}! I even gave you #{old_weapon.cost / 2} gold for that old #{old_weapon.name}!"
			return true
		else
			puts "I am sorry, you don't have enough gold, and I don't do charity!"
			return false
		end
	end

	def level_up
		@level = @level + 1
		@xp = @xp - 100
		puts "You are now a level #{@level}!"
	end

	def inn(cost)
		if @gold >= cost
			@gold = @gold - cost
			puts "You pay the tab, and walk up to your room, where you get a good rest, and all your injuries magically heal."
			@hp = @hp_max
			return true
		else
			puts "I'm sorry, hon. You've got to pay to stay."
			return false
		end
	end


end