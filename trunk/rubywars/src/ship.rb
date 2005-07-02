# Ship class definitions
# 
# This is one part of:
#
# Rubywars (working title) --  A scrolling space shooter game
# Copyright (C) Greg Colombo, John Croisant 2005

# Goal: the ship can 'shoot' projectile bullets in the direction it's facing.

require 'src/projectile'
require 'rubygame'

class Ship < Projectile
	def draw(surf)
		super
		0.upto(10) do |t|
			v = project(t)
			surf.fill([250-(t*15)]*3, # darkening grayscale
					  [v.x-2, v.y-2, 2, 2]) # square around point
		end
	end
end
