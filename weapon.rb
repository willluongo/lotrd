require './item.rb'

class Weapon < Item
	attr_reader :damage, :cost
	def initialize(name, use, damage, cost)
		super(name, use)
		@damage = damage
		@cost = cost
	end
end