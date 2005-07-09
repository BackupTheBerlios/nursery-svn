# Game event definitions
# 
# This is one part of:
#
# Rubywars (working title) --  A scrolling space shooter game
# Copyright (C) Greg Colombo, John Croisant 2005

class GameEvent
end

class NewObjectEvent
	def initialize(id,object)
		@object = object
		@id = id
	end

	def to_net
		"NewObject(#{@id})=#{@object.to_net}"
	end
end
