# Bullet class definitions
# 
# This is one part of:
#
# Rubywars (working title) --  A scrolling space shooter game
# Copyright (C) Greg Colombo, John Croisant 2005

require 'src/projectile'
require 'rubygame'

class Bullet < Projectile
	# Create a new Bullet.
	# 
	# +pos+::    object's position Vector (pixels).
	# +vel+::    object's velocity Vector (pixels/sec).
	# +angle+::  object's angle (radians). 0 = right, pi/2 = down, and so on
	# +life+::   how long the object persists (in seconds) before dying.
	def initialize(pos, vel, life)
		image= Rubygame::Surface.new([2,2])
		image.fill([250,250,100])
		# super(image,pos,vel,angle,accel,spin)
		super(image,pos,vel,0,Vector.new(0,0),0)
		@born = Rubygame::Time.get_ticks()
		@life = life
	end

	def update(dt)
		now = Rubygame::Time.get_ticks()
		if (now - @born > @life)
			self.kill()			# remove from sprite groups
		end
		super
	end
		
end
