# Game event definitions
# 
# This is one part of:
#
# Rubywars (working title) --  A scrolling space shooter game
# Copyright (C) Greg Colombo, John Croisant 2005

# A generic Event class, meant to be subclassed.
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

# Send the given game signal (usually a :symbol) to an object.
# How the object behaves in response to a signal is left to
# the object to decide.
class SignalEvent < GenericEvent
	attr_reader :sig
	attr_reader :extra
	def initialize(id,t,sig,*extra)
		super(id,t)
		@sig = sig
		@extra = extra
	end

	def to_net
		"Signal(#{@id},#{@sig.to_s})"
	end
end

# A new object has been created and assigned an ID number.
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

# The game should quit
class QuitEvent < GenericEvent
end


