#!/usr/bin/env ruby

# Initialization and main loop
# 
# This is one part of:
#
# Rubywars (working title) --  A scrolling space shooter game
# Copyright (C) Greg Colombo, John Croisant 2005

require 'rubygame'
require 'src/game'
require 'src/events'
require 'src/input'
require 'src/ship'
require 'src/launcher'
require 'src/bullet'

Rubygame.init()

def main

	$game = Game.new() do
		|game,input|

		# Generate ship image, a white triangle inside a gray triangle
		game.bag[:ship] = "data/ship1.png"

		ship = Ship.new(game.bag[:ship],               # surface
						Vector.new(320,240), # pos
						Vector.new(0,0),     # vel
						0,	                 # angle
						Vector.new(10,0),     # accel
						1)	                 # spin
		ship.add_launcher(Launcher,Bullet,1000)

		ship = game.associate_sprite(ship) # ID number

		input.bind_many(
						# bind to key press
						[Rubygame::K_RETURN,   ship, :report],
						[Rubygame::K_SPACE,    ship, :shoot],
						[Rubygame::K_LEFT,     ship, :thrust_acw],
						[Rubygame::K_RIGHT,    ship, :thrust_cw],
						[Rubygame::K_UP,       ship, :thrust_aft],

						# bind to key release
						[-(Rubygame::K_LEFT),  ship, :nothrust_acw],
						[-(Rubygame::K_RIGHT), ship, :nothrust_cw],
						[-(Rubygame::K_UP),    ship, :nothrust_aft],

						# system events
						[Rubygame::K_Q,        1,    :quit],
						[Rubygame::K_ESCAPE,   1,    :quit]
						)
	end

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
			$game.update()
		end                     # end loop
	end                         # end catch
end                             # end def

#this calls the 'main' function when this script is executed
if $0 == __FILE__
	main()
end
