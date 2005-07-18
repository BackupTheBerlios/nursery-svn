# Game event definitions
# 
# This is one part of:
#
# Rubywars (working title) --  A scrolling space shooter game
# Copyright (C) Greg Colombo, John Croisant 2005

class GenericEvent
	attr_reader :id, :t

	# +id+:: ID number of the object that the event describes
	# +t+::  event timestamp
	def initialize(id,t)
		@id = id
		@t = t
	end

	def to_net
		"#{self.class}(#{@id})"
	end
end

class NewObjectEvent < GenericEvent
	attr_reader :obj

	# +id+::  ID number of the object that the event describes
	# +t+::   event timestamp
	# +obj+:: the new object
	def initialize(id,t,obj)
		super(id,t)
		@object = obj
	end

	def to_net
		"NewObject(#{@id},#{@obj.to_net})"
	end
end

class QuitEvent < GenericEvent
end

