# Ship class definitions
# 
# This is one part of:
#
# Rubywars (working title) --  A scrolling space shooter game
# Copyright (C) Greg Colombo, John Croisant 2005

#require 'projectile'

# For now, we'll define the Ship class, then generalize it as a
# Projectile class.
# 
# Goal: A ship which can move and be steered with keyboard controls

require 'src/vector'

class Ship
	include Rubygame::Sprite::Sprite

	# All the writers should be removed eventually (when testing is done).
	# Only the ship should be able to directly affect itself.
	# Everything else just requests that the ship do something.

	def x; @pos.x; end
	def x=(v); @pos.x=(v); end

	def y; @pos.y; end
	def y=(v); @pos.y=(v); end

	def vx; @vel.x; end
	def vx=(v); @vel.x=(v); end

	def vy; @vel.y; end
	def vy=(v); @vel.y=(v); end
	
	attr_accessor :angle

	# Create a new Ship.
	# 
	# +image+::  a Surface showing the ship pointing to the right.
	# +pos+::    Ship's position Vector (pixels).
	# +vel+::    Ship's velocity Vector (pixels/sec).
	# +angle+::  Ship's angle (radians). 0 = right, pi/2 = down, and so on
	# +accel+::  a Vector of acceleration (pixels/sec^2) when the ship
	#            accelerates while facing to the right (angle = 0).
	#            This Vector will be rotated as the ship rotates, so it will
	#            maintain its angle, relative to the ship's angle.
	# +spin+::   How fast the ship can rotate iteslf (radians/sec)
	def initialize(image, pos, vel, angle, accel, spin)
		super()
		@base_image = image
		@pos = pos
		@vel = vel
		@angle = angle
		@old_angle = angle
		@accel = accel			# reference acceleration vector
		@a = Vector.new(0,0)	# the direction it _is_ accelerating
		@spin = spin			# how fast it can rotate
		@avel = 0				# angular vel (how fast it IS rotating)
		
		@t = 0
		self.stamp				# set initial position and velocity

		@image = image
		@rect = Rubygame::Rect.new( @pos.to_a + @image.size)
	end

	# Set the "initial" position and velocity to current values.
	# This is called when the Ship's acceleration changes, or when the old
	# position model is otherwise made obsolete. 
	def stamp
		now = Rubygame::Time.get_ticks()
		t = now - @t
		@pos.x, @pos.y = project(t)
		@t = now
	end

	# Predict where the Ship will be +t+ milliseconds after initialization, if
	# it maintains its current acceleration, using the familiar formula:
	# 
	#   p = p0  +  v0 * t  +  0.5 * a * t^2
	# 
	# (where p = curr. position, p0 = init. pos., v0 = init. vel., a = accel.,
	# and t = time since init.)
	def project(t)
		t2 = t*t/2 # one half t-squared
		Vector.new(@pos.x + @vel.x*t + @a.x*t2,
				   @pos.y + @vel.y*t + @a.y*t2)
	end

	# Update object's position and angle
	def update(dt)
		# We totally ignore dt, which is for use with incremental models.
		# Projection models (such as this one) are not distinguished from
		# incremental models.

		now = Rubygame::Time.get_ticks()
		t = now - @t			# how long since last stamp()
		t = t / 1000			# convert to seconds

		@angle += @avel * t
		unless @angle == @old_angle
			@image = Rubygame::Transform.rotozoom(@base_image,@angle,1)
		end
		@old_angle = @angle

		p = project(t)
		@rect.center = p.x.to_i, p.y.to_i
	end

	# Begin rotating counter-clockwise. Because positive Y value are "down" 
	# for SDL, this means we DECREASE the angle to go counter-clockwise.
	def start_rotate_left
		@avel = -@spin
	end

	# Begin rotating clockwise. Because positive Y value are "down" for SDL,
	# this means we INCREASE the angle to go clockwise.
	def start_rotate_right
		@avel = @spin
	end

	# Stop rotating.
	def stop_rotate
		@avel = 0
	end

	# Begin accelerating from thrusters.
	def start_thrust
		@a = @accel.rotate(@angle)
	end

	# Stop accelerating from thrusters.
	def stop_thrust
		@a = [0,0]
	end
end
