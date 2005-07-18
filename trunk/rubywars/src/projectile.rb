# Projectile class definitions
# 
# This is one part of:
#
# Rubywars (working title) --  A scrolling space shooter game
# Copyright (C) Greg Colombo, John Croisant 2005

require 'src/vector'
require 'rubygame'

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
	
	attr_accessor :stamp

	# Create a new Projectile.
	# 
	# +image+::  a Surface showing the object
	# +pos+::    object's position Vector (pixels).
	# +vel+::    object's velocity Vector (pixels/sec).
	def initialize(image,pos, vel)
		super()
		@pos = Vector.new(pos)
		@vel = Vector.new(vel)

		now = Rubygame::Time.get_ticks()
		@stamp = {
			:p => now,			# last time position was stamped
		}
		
		stamp_pos()					# set initial position and velocity

		@base_image = image
		@image = image
		@rect = Rubygame::Rect.new( [0,0].concat(@image.size) )
		@rect.center = @pos.x.to_i, @pos.y.to_i
	end

	def inspect
		"#<#{self.class}:#{self.object_id} [%0.3f, %0.3f]"%[@pos.x,@pos.y]
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

	# Predict where the Ship will be +t+ milliseconds after initialization, if
	# it maintains its current acceleration, using the familiar formula:
	# 
	#   p = p0  +  v0 * t  +  0.5 * a * t^2
	# 
	# (where p = curr. position, p0 = init. pos., v0 = init. vel., a = accel.,
	# and t = time since init.)
	def project(t)
		t2 = t*t/2 # one half t-squared
		return Vector.new(@pos.x + @vel.x*t,
						  @pos.y + @vel.y*t)
	end

	# Predict what the Ship's velocity will be +t+ milliseconds after 
	# initialization, if it maintains its current acceleration.
	def project_vel(t)
		return @vel
	end

	# Print the ship's angle and the formula being used to project
	# position. For debugging purposes and curious people.
	def report()
		t = (Rubygame::Time.get_ticks() - @stamp[:p])/1000.0
		v = Vector.new(@pos.x + @vel.x*t, @pos.y + @vel.y*t)
		puts "project: #{@pos} + #{@vel}*#{t} = #{v}"
	end

	# Update object's position and angle
	def update(dt)
		# We totally ignore dt, which is for use with incremental models.
		# Projection models (such as this one) are not distinguished from
		# incremental models when viewed from the outside.

		now = Rubygame::Time.get_ticks()
		# how long since last stamp_pos(), in seconds.
		ptime = (now - @stamp[:p])/1000.0

		p = project(ptime).to_a
		@rect.center = p
	end
end
