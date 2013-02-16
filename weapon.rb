require './item.rb'

class Weapon < Item
	attr_reader :damage
	def initialize(name, use, damage)
		super(name, use)
		@damage = damage
	end
end