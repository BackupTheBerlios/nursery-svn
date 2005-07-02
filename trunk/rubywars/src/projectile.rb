# Projectile class definitions
# 
# This is one part of:
#
# Rubywars (working title) --  A scrolling space shooter game
# Copyright (C) Greg Colombo, John Croisant 2005

require 'src/vector'
require 'rubygame'

PI_OVER_ONE_EIGHTY = Math::PI/180
ONE_EIGHTY_OVER_PI = 180/Math::PI

def deg2rad(deg)
	return deg * PI_OVER_ONE_EIGHTY
end

def rad2deg(rad)
	return rad * ONE_EIGHTY_OVER_PI
end


class Projectile
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

	# Create a new Projectile.
	# 
	# +image+::  a Surface showing the object pointing to the right.
	# +pos+::    object's position Vector (pixels).
	# +vel+::    object's velocity Vector (pixels/sec).
	# +angle+::  object's angle (radians). 0 = right, pi/2 = down, and so on
	# +accel+::  a Vector of acceleration (pixels/sec^2) when the object
	#            accelerates while facing to the right (angle = 0).
	#            This Vector will be rotated as the object rotates, so it will
	#            maintain its angle, relative to the object's angle.
	# +spin+::   How fast the object can rotate iteslf (radians/sec)
	def initialize(image, pos, vel, angle, accel, spin)
		super()
		@base_image = image
		@pos = Vector.new(pos)
		@vel = Vector.new(vel)
		@angle = angle			# current angle
		@base_angle = angle		# angle at last stamp()
		@accel = accel			# reference acceleration vector
		@a = Vector.new(0,0)	# the direction it _is_ accelerating
		@spin = spin			# how fast it CAN rotate, rads/sec

		# Number of keys activating each thrust. We can't use true/false
		# because two or more keys might be bound to one thruster.
		# In such a case, releasing only one key should not stop thrust.
		# 
		# Value is incremented when the key is pressed, and decremented when
		# released, so neutral should be zero. Anything greater than zero
		# means "active", and anything lesser than zero is a bug!
		@thrust = {
			:aft => 0,		# causes forward motion.
			:cw => 0,		# causes clockwise rotation.
			:acw => 0,		# causes anti-clockwise rotation.
		}

		now = Rubygame::Time.get_ticks()
		@stamp = {
			:p => now,			# last time position was stamped
			:a => now			# last time angle was stamped
		}
		
		stamp_pos()					# set initial position and velocity

		@image = image
		@rect = Rubygame::Rect.new( [0,0].concat(@image.size) )
		@rect.center = @pos.x.to_i, @pos.y.to_i
	end

	# Set the "initial" position and velocity to current values.
	# This is called when the Ship's acceleration changes, or when the old
	# position model is otherwise made obsolete. 
	def stamp_pos
		now = Rubygame::Time.get_ticks()
		t = (now - @stamp[:p])/1000.0
		@pos.set!( project(t) )
		@vel.set!( project_vel(t) )
		@stamp[:p] = now
	end

	def stamp_angle
		now = Rubygame::Time.get_ticks()
		@base_angle = @angle
		@stamp[:a] = now
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
	# initialization, if it maintains its current acceleration.
	def project_vel(t)
		return Vector.new(@vel.x + @a.x*t,
						  @vel.y + @a.y*t)
	end

	# Print the ship's angle and the formula being used to project
	# position. For debugging purposes and curious people.
	def report()
		t = (Rubygame::Time.get_ticks() - @stamp[:accel])/1000.0
		t2 = t*t/2 # one half t-squared
		v = Vector.new(@pos.x + @vel.x*t + @a.x*t2,
						  @pos.y + @vel.y*t + @a.y*t2)
		puts "angle = #{@angle}"
		puts "project: #{@pos} + #{@vel}*#{t} + #{@a}*#{t2} = #{v}"
	end

	# Recalculate the angle of acceleration of the ship, e.g. when
	# the ship rotates.
	def recalc_accel()
		stamp_pos()
		if @thrust[:aft] > 0
			@a.set!(@accel.rotate(@angle))
		else
			@a.set!(0,0)
		end
	end

	# Returns true if the ship is rotating in either direction.
	def spinning?()
		(@thrust[:cw] > 0)  ^  (@thrust[:acw] > 0)
		# I don't know if it's proper to use bitwise operators on booleans,
		# but it works, and I need an XOR operator.
	end

	# Returns the net rotation effect on the ship, of the following:
	#   0 (no rotation, e.g. neither or both rotationary thrusters active)
	#   1 (clockwise rotation)
	#  -1 (anti-clockwise rotation)
	def net_spin()
		if @thrust[:cw] > 0
			@thrust[:acw] > 0  ?  0  :  1
		else
			@thrust[:acw] > 0  ?  -1  :  0
		end
	end

	# Update object's position and angle
	def update(dt)
		# We totally ignore dt, which is for use with incremental models.
		# Projection models (such as this one) are not distinguished from
		# incremental models when viewed from the outside.

		now = Rubygame::Time.get_ticks()
		# how long since last stamp_pos(), in seconds.
		ptime = (now - @stamp[:p])/1000.0


		if spinning?()
			# how long since last stamp_angle(), in seconds.
			atime = (now - @stamp[:a])/1000.0
			
			@angle = @base_angle + @spin * net_spin() * atime

			unless @a == [0,0]
				recalc_accel()
			end

			degrees = rad2deg(-@angle)
			@image = Rubygame::Transform.rotozoom(@base_image,degrees,1)
			@rect = Rubygame::Rect.new( [0,0].concat(@image.size) )
		end

		p = project(ptime).to_a
		@rect.center = p
	end

	# Begin rotating anti-clockwise.
	def start_thrust_acw
		@thrust[:acw] += 1
		stamp_angle()
	end

	# Begin rotating clockwise.
	def start_thrust_cw
		@thrust[:cw] += 1
		stamp_angle()
	end

	# Stop rotating anti-clockwise.
	def stop_thrust_acw
		@thrust[:acw] -= 1 unless @thrust[:acw] < 1
	end

	# Stop rotating clockwise.
	def stop_thrust_cw
		@thrust[:cw] -= 1 unless @thrust[:cw] < 1
	end


	# Begin accelerating forward from aft thrusters.
	def start_thrust_aft
		@thrust[:aft] += 1
		recalc_accel()
	end

	# Stop accelerating forward from aft thrusters.
	def stop_thrust_aft
		@thrust[:aft] -= 1 unless @thrust[:aft] < 1
		recalc_accel()
	end
end
