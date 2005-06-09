#!/usr/bin/env ruby

# Initialization and main loop
# 
# This is one part of:
#
# Rubywars (working title) --  A scrolling space shooter game
# Copyright (C) Greg Colombo, John Croisant 2005

require 'rubygame'
require 'src/ship'

Rubygame.init()

def main

	# For now this is just a test, so we can do dirty stuff like
	# use global variables. We MIGHT want to change this later.

	$screen = Rubygame::Display.set_mode([640,480])
	$screen.set_caption("Rubywars")
	$queue = Rubygame::Queue.instance()
	$clock = Rubygame::Time::Clock.new()

	$image = Rubygame::Surface.new([100,100])
	Rubygame::Draw.polygon($image,[[0,0],[100,50],[0,100],[0,0]],[150,150,150])

	$ship = Ship.new($image, 		# surface
					 Vector.new(320,240), # pos
					 Vector.new(1,0), # vel
					 0,				# angle
					 Vector.new(0.1,0),	# accel
					 0.1)			# spin

# Basic overview of (finished) game loop:
#   - Each object checks if armor < 1. If so, it dies.
#   - Check for player input
#     - If player fired a weapon, create the projectile object
#   - Update object locations
#   - Check collision with other objects
#     - If object is colliding with another object, deal @crash damage
#     - (Object doesn't die immediately, so it might deal damage back when
#        it is that object's turn to check collision)
#   - Redraw/update relevant parts of screen

# Overview of CURRENT game loop:
#   - Check for player input (and quit on Q, Escape, or Close)
	catch(:quit) do
		loop do
			$queue.get.each do |event|
				# Later, we'll want to make a general event processing model
				case event
				when Rubygame::QuitEvent
					throw :quit
				when Rubygame::KeyDownEvent
					case event.key
					when Rubygame::K_Q, Rubygame::K_ESCAPE
						throw :quit
					end
				end				# end case event
			end					# end get
		end						# end loop
	end							# end catch
		
end								# end def

#this calls the 'main' function when this script is executed
if $0 == __FILE__
	main()
end
