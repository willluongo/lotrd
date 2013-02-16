class Character
	attr_reader :name, :hp, :level, :initiative, :weapon
	def initialize(name)
		@name = name
		@hp = 10
		@level = 1
		@initiative = 4
	end

	def attack(target)
		raise NotImplementedError, "You need to make sure you implement the #{__method__} method"
	end

	def defend(attacker)
		raise NotImplementedError, "You need to make sure you implement the #{__method__} method"
	end

end
