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

class UpdateGroup < Rubygame::Sprite::Group
	include Rubygame::Sprite::UpdateGroup
end

def main

	# For now this is just a test, so we can do dirty stuff like
	# use global variables. We MIGHT want to change this later.

	$screen = Rubygame::Display.set_mode([640,480])
	$screen.set_caption("Rubywars")
	$queue = Rubygame::Queue.instance()
	$clock = Rubygame::Time::Clock.new()
#	$clock.desired_mspf = 1

	$background = Rubygame::Surface.new($screen.size)
	$background.fill([0,0,0])

	$image = Rubygame::Surface.new([50,50])
	# Grey body
	Rubygame::Draw.filled_polygon($image,
								  [[0,0],[50,25],[0,50],[0,0]],
								  [150,150,150])
	# White tip
	Rubygame::Draw.filled_polygon($image,
								  [[35,20],[45,25],[35,30],[35,20]],
								  [250,250,250])


	$ship = Ship.new($image,             # surface
					Vector.new(320,240), # pos
					Vector.new(0,0),     # vel
					0,	                 # angle
					Vector.new(1,0),     # accel
					1)	                 # spin

	$sprites = UpdateGroup.new()
	$sprites.push($ship)
											  

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
#   - Update object locations
#   - Redraw/update relevant parts of screen
	catch(:quit) do
		loop do
			$queue.get.each do |event|
				# Later, we'll want to make a general event processing model
				case event
				when Rubygame::QuitEvent
					throw :quit
				when Rubygame::KeyDownEvent	# key is pressed
					case event.key
					when Rubygame::K_Q, Rubygame::K_ESCAPE
						throw :quit
					when Rubygame::K_SPACE
						$ship.report()
					when Rubygame::K_LEFT
						$ship.start_rotate_left()
					when Rubygame::K_RIGHT
						$ship.start_rotate_right()
					when Rubygame::K_UP
						$ship.start_thrust()
					end
				when Rubygame::KeyUpEvent # key is released
					case event.key
					when Rubygame::K_LEFT
						$ship.stop_rotate()
					when Rubygame::K_RIGHT
						$ship.stop_rotate()
					when Rubygame::K_UP
						$ship.stop_thrust()
					end
				end             # end case event
			end	                # end each

			$sprites.undraw($screen,$background)

			# Update ship's position. The value of $clock.tick is
			# actually ignored by the ship (in this case), but it has the
			# side-effect of delaying execution.

			$sprites.update($clock.tick())

			# Draw the ship to the screen. It will leave a 'tail' for now.
			$sprites.draw($screen)

			# Refresh the display window.
			$screen.update()
			$screen.set_caption("Rubywars [#{$clock.fps} fps]")
			

		end                     # end loop
	end                         # end catch

end                             # end def

#this calls the 'main' function when this script is executed
if $0 == __FILE__
	main()
end
