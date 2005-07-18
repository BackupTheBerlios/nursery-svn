# Game class definitions
# 
# This is one part of:
#
# Rubywars (working title) --  A scrolling space shooter game
# Copyright (C) Greg Colombo, John Croisant 2005

require 'rubygame'
require 'src/input'
require 'src/events'

# Class Game is responsible for coordinating all game behavior.
# Game maintains a list of 
# 
# Input handling is delegated to an InputHandler instance.
# 
# 
class Game
	# Attr_accessors should eventually be removed/replaced.
	attr_accessor :sprites, :input
	attr_reader :queue, :objects

	def initialize(&b)
		# game events are stored here
		@queue = []

		# input event handler (keyboard, mouse, etc.)
		@input = InputHandler.new(self)

		@clock = Rubygame::Time::Clock.new()
#		@clock.desired_mspf = 50

		@screen = Rubygame::Display.set_mode([640,480])
		@screen.set_caption("Rubywars")

		@background = Rubygame::Surface.new(@screen.size)
		@background.fill([0,0,0])

		@sprites = Rubygame::Sprite::Group.new()
		@sprites.extend Rubygame::Sprite::UpdateGroup

		# hash of game objects by ID.
		# IDs 1 to 999 are reserved for local system objects.
		# Normal/networked objects are given integers from 1000
		# to 10,000 (usually chosen randomly).
		@objects = {1 => self, 2 => @input}

		if block_given?
			case b.arity
			when 1
				yield self
			when 2
				yield self, @input
			when 3
				yield self, @input, @clock
			end
		end
	end

	# Register the given game object under the given integer ID,
	# and return the ID number. See also #associate_sprite
	# 
	# If no ID is specified (or the ID is not an integer), a random
	# integer from 1000 to 10,000 is assigned to that object.
	# 
	# If an ID is specified, but that ID is already taken, no
	# association is performed, and +StandardError+ is raised.
	def associate(obj,id=nil)
		if (id and id.is_a? Integer)
			raise(StandardError,"ID #{id} is already taken.") if @objects[id]
		else
			id = generate_new_id()
		end

		unless @objects[id]
			@objects[id] = obj
		end

		return id
	end

	# Associates the object as normal (see #associate), but
	# (if the object is actually a sprite) it will also be added
	# to a sprite group which is updated and drawn each frame.
	def associate_sprite(obj,id=nil)
		id = associate(obj,id)
		if obj.is_a? Rubygame::Sprite::Sprite
			@sprites.push(obj)
		end
		return id
	end

	# Deliver the given game event to its corresponding game object.
	def deliver(ev)
		begin
			lookup(ev.id).tell(ev)
		rescue NoMethodError => error
			puts "Gameman: Error delivering event to object #{ev.id}:"
			puts error
		end
	end

	def disassociate(id)
		@objects.delete(id)
	end

	def flush()
		@queue.each do |ev|
			self.deliver(ev)
		end
		@queue.clear
	end

	# Generate a random integer in 1000 to 10,000. If a known object
	# with that ID number exists, choose another random integer.
	def generate_new_id()
		begin
			(id = rand(9000)+1000)
		end while @objects[id]
		return id
	end

	# Return the ID number for an object, or +nil+ if that object
	# is not associated with an ID.
	def get_id(obj)
		@objects.invert[obj]
	end

	# Return a reference to the game object corresponding to the given
	# ID number, or +nil+ if there is no object with that ID.
	def lookup(id)
		@objects[id]
	end

	# Append the given event to the queue, to be delivered at next update()
	def post(ev)
		@queue << ev
	end

	# Tell the Game about a game event.
	def tell(ev)
		case ev.sig
		when :quit
			throw :quit
		end
	end

	def update()
		now = Rubygame::Time.get_ticks()

		@input.update(now)
		self.flush()

		@sprites.undraw(@screen,@background)

		# Update ship's position. The value of $clock.tick is
		# actually ignored by the ship (in this case), but it has the
		# side-effect of delaying execution.

		@sprites.update(@clock.tick())

		# Draw the ship to the screen. It will leave a 'tail' for now.
		@sprites.draw(@screen)

		# Refresh the display window.
		@screen.update()
		@screen.set_caption("Rubywars [#{@clock.fps} fps]")

	end
end
