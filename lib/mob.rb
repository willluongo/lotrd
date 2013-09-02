require_relative 'char.rb'

class Mob < Character
	attr_reader :alive
	def initialize(name, hp, max_damage, weapon, death = "The #{name} falls quietly to his death.")
		super(name)
		@hp = hp
		@weapon = weapon
		@death = death
		@alive = true
		@max_damage = max_damage
	end

	def attack(target)
		rnd = Random.new(Time.now.to_i)
		damage = rnd.rand(@max_damage)
		if damage > 0
			puts "The #{@name} uses his #{@weapon}!"
			target.defend(damage, @name, @weapon)
		else
			puts "The #{@name} displays his #{@weapon}, but doesn't attack you."
		end

	end

	def defend(damage)
		@hp = @hp - damage
		if @hp <= 0 
			die
		else
			puts "The #{@name} takes #{damage} damage, but has #{@hp} remaining!"
		end
	end

	def die
		puts @death
		@alive = false
	end


end
