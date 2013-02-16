require './item.rb'

class Armor < Item
	attr_reader :armor_value
	def initialize(name, use, armor_value)
		super(name, use)
		@armor_value = armor_value
	end
end
