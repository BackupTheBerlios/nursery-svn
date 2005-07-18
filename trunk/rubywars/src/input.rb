# Input handler definitions
# 
# This is one part of:
#
# Rubywars (working title) --  A scrolling space shooter game
# Copyright (C) Greg Colombo, John Croisant 2005

require 'rubygame'
require 'src/events'

class InputHandler
	attr_accessor :bindings
	def initialize(game,queue=nil)
		@bindings = {}
		@game = game
		@queue = (queue or Rubygame::Queue.instance())
	end

	# Bind the given key to an object and event class. When #handle
	# is called with +key+, +obj.tell+ will be called with an instance
	# of Signal. The remaining arguments will be passed to Signal#new,
	# after the two required arguments, object ID and current time.
	# 
	# To bind an event to the _release_ of a key, bind to the opposite
	# (negative) of the key value.
	#
	# See also #bind_many
	def bind(key,obj,*args)
		@bindings[key] = [obj,*args]
	end

	# Bind many keys at once. +*args+ must be an Array of many sub-Arrays;
	# each sub-Array must hold arguments for #bind (e.g. +[key,obj,eklass]+).
	def bind_many(*args)
		args.each do |ary|
			bind(*ary)
		end
	end

	# Generate a game event and post it for delivery to an object.
	# The event type and recipient are determined by current bindings.
	# See #bind and #bind_many.
	def handle(key, t)
		b = @bindings[key]
		if b
			@game.post(SignalEvent.new( b[0], t, *b[1]))
			true
		else
			nil
		end
	end

	# Remove all bindings from a key.
	def unbind(key)
		@bindings[key] = nil
	end

	# Fetch and handle all SDL keyboard and quit events, posting
	# corresponding game events to the master Game instance.
	def update(t)
		@queue.get.each do |event|
			case event
			when Rubygame::QuitEvent
				@game.post(SignalEvent.new(1,t,:quit))

			when Rubygame::KeyDownEvent	# key is pressed
				unless handle(event.key, t)
					#warn "No binding for key #{event.key}"
				end

			when Rubygame::KeyUpEvent	# key is released
				unless handle(-(event.key), t)
					#warn "No binding for key #{-(event.key)}"
				end
			end
		end
	end

end
