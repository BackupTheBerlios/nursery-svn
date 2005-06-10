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
		@pos = Vector.new(pos)
		@vel = Vector.new(vel)
		@angle = angle			# current angle
		@base_angle = angle		# angle at last stamp()
		@accel = accel			# reference acceleration vector
		@a = Vector.new(0,0)	# the direction it _is_ accelerating
		@spin = spin			# how fast it CAN rotate
		@avel = 0				# angular vel (how fast it IS rotating)
		
		@t = Rubygame::Time.get_ticks()
		stamp()					# set initial position and velocity

		@image = image
		@rect = Rubygame::Rect.new( [0,0].concat(@image.size) )
		@rect.center = @pos.x.to_i, @pos.y.to_i
	end

	# Set the "initial" position and velocity to current values.
	# This is called when the Ship's acceleration changes, or when the old
	# position model is otherwise made obsolete. 
	def stamp
		now = Rubygame::Time.get_ticks()
		t = now - @t
		@pos.set!( project(t) )
		@vel.set!( project_vel(t) )
		@base_angle = @angle
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
		return Vector.new(@pos.x + @vel.x*t + @a.x*t2,
						  @pos.y + @vel.y*t + @a.y*t2)
	end

	# Predict what the Ship's velocity will be +t+ milliseconds after 
	# initialization,
	def project_vel(t)
		return Vector.new(@vel.x + @a.x*t,
						  @vel.y + @a.y*t)
	end

	# Update object's position and angle
	def update(dt)
		# We totally ignore dt, which is for use with incremental models.
		# Projection models (such as this one) are not distinguished from
		# incremental models when viewed from the outside.

		now = Rubygame::Time.get_ticks()
		t = now - @t			# how long since last stamp()
		t = t / 1000			# convert to seconds

		unless @avel == 0
			@angle = @base_angle + @avel * t
			@image = Rubygame::Transform.rotozoom(@base_image,@angle,1)
			@rect = Rubygame::Rect.new( [0,0].concat(@image.size) )
			@rect.center = @pos.x.to_i, @pos.y.to_i
		end

		p = project(t).to_a
		@rect.center = p
	end

	# Begin rotating counter-clockwise. Because positive Y value are "down" 
	# for SDL, this means we DECREASE the angle to go counter-clockwise??
	# I guess not?
	def start_rotate_left
		@avel = @spin
	end

	# Begin rotating clockwise. Because positive Y value are "down" for SDL,
	# this means we INCREASE the angle to go clockwise??
	# I guess not?
	def start_rotate_right
		@avel = -@spin
	end

	# Stop rotating.
	def stop_rotate
		@avel = 0
	end

	# Begin accelerating from thrusters.
	def start_thrust
		stamp()					# accel changes, so we must stamp
		@a.set!(@accel.rotate(@angle))
	end

	# Stop accelerating from thrusters.
	def stop_thrust
		stamp()					# accel changes, so we must stamp
		@a.set!(0,0)
	end
end
