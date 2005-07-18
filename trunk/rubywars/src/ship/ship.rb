# Ship class definitions
# 
# This is one part of:
#
# Rubywars (working title) --  A scrolling space shooter game
# Copyright (C) Greg Colombo, John Croisant 2005

require 'src/rocket/rocket'
require 'src/ship/events'
require 'rubygame'

class Ship < Rocket
	def initialize(*args)
		super
		@launch = []
	end


	# Draw the ship using the default Rubygame Sprite draw() method.
	# Additionally, several points are drawn, which show the Ship's
	# projected location at integer times 0-10 (seconds) after last
	# #stamp_pos().
	def draw(surf)
		super
		0.upto(10) do |t|
			v = project(t)
			surf.fill([250-(t*15)]*3, # darkening grayscale
					  [v.x-2, v.y-2, 2, 2]) # square around point
		end
	end

	# Create and "attach" a new Launcher instance to the Ship.
	# 
	# +klass+:: the class of Launcher to create.
	# +*args+:: arguments to pass to +klass.new()+ (e.g. lifespan)
	def add_launcher(klass,*args)
		@launch << klass.new(self,*args)
	end

	# Iterate through all Launchers attached to the Ship, and shoot
	# each of them.
	def shoot
		@launch.each do |l|
			l.shoot()
		end
	end

	def tell(ev)
		case ev.sig
		when :shoot
			shoot()
		else
			super(ev)
		end
	end
end
