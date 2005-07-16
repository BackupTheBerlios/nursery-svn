# Input handler definitions
# 
# This is one part of:
#
# Rubywars (working title) --  A scrolling space shooter game
# Copyright (C) Greg Colombo, John Croisant 2005

require 'rubygame'

class InputHandler
	attr_accessor :bindings
	def initialize()
		@bindings = {}
		@queue = Rubygame::Queue.instance()
	end

	# Bind the given key to an object and event class. When #handle
	# is called with +key+, +obj.tell+ will be called with an instance
	# of +eklass+.
	# 
	# To bind an event to the _release_ of a key, bind to the opposite
	# (negative) of the key value.
	def bind(key,obj,eklass)
		@bindings[key] = [obj,eklass]
	end

	# Bind many keys at once. +*args+ must be an Array of many sub-Arrays;
	# each sub-Array must hold arguments for #bind (e.g. +[key,obj,eklass]+).
	def bind_many(*args)
		args.each do |ary|
			bind(*ary)
		end
	end

	# Pass an event instance to an object, based on the current bindings.
	# See #bind.
	def handle(key)
		b = @bindings[key]
		if b
			b[0].tell( b[1].new( 0, 0 ))
			# @gameman.tell( b[1].new( b[0], Rubygame::Time.get_ticks() ))
			true
		else
			nil
		end
	end

	def update()
		@queue.get.each do |event|
			case event
			when Rubygame::QuitEvent
				throw :quit
			when Rubygame::KeyDownEvent	# key is pressed
				unless handle(event.key)
					warn "No binding for key #{event.key}"
				end
			when Rubygame::KeyUpEvent	# key is released
				unless handle(-(event.key))
					warn "No binding for key #{-(event.key)}"
				end
			end
		end
	end

end
