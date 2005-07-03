# Launcher class definitions
#
# This is one part of:
#
# Rubywars (working title) --  A scrolling space shooter game
# Copyright (C) Greg Colombo, John Croisant 2005

require 'src/vector'

class Launcher
	attr_accessor :parent, :type, :lifespan

	# Create a new Launcher object, "attached" to a parent object.
	# 
	# +parent+::    object to "attach" the Launcher to.
	# +type+::      class of Projectile the Launcher creates.
	# +lifespan+::  how long (milliseconds) the launched Projectiles persist.
	def initialize(parent, type, lifespan)
		@parent = parent
		@type = type
		@lifespan = lifespan
	end

	# Spawn and launch a new Projectile object. The Projectile will inherit
	# the Launcher's parent's position and velocity (plus some extra velocity).
	# 
	# The class and lifespan of the Projectile are governed by @type and
	# @lifespan, which are set when the Launcher is created.
	def shoot
		t = (Rubygame::Time.get_ticks() - @parent.stamp[:p])/1000.0
		v = Vector.new(1,0).rotate(@parent.angle)
		v.magnitude += 150
		p = @parent.project(t)
		@parent.groups[0].push(@type.new(p,v,@lifespan))
	end
end
