require_relative './item.rb'

class Armor < Item
	attr_reader :armor_value, :cost
	def initialize(name, use, armor_value, cost)
		super(name, use)
		@armor_value = armor_value
		@cost = cost
	end
end
