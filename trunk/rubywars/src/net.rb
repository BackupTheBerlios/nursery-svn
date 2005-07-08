# Networking system definitions
# 
# This is one part of:
#
# Rubywars (working title) --  A scrolling space shooter game
# Copyright (C) Greg Colombo, John Croisant 2005

require 'socket'

# Class `Player' represents a human player with a corresponding Ship object,
# name, and Internet Protocol address. Events are forwarded to the Player
# from Netman.
class Player
	attr_accessor :name, :addy, :ship
end

# Networking Manager (Netman)
# 
# Netman handles networking events, sending and receiving game state
# changes from other game clients. Netman can act as either a server
# or a client, or both. (All Netmans, whether server, client, or both, will
# hereafter be referred to as clients.)
# 
# All game state events pass through Netman (both local and remote events).
# Local events will be sent to other clients via the network, and to the
# local objects they describe. Remote events received from other clients
# via the network will be sent to the local objects they describe.
class Netman
	def initialize
		@queue = []				# game events are stored here
		@objects = {}			# hash of game objects by identifier number
		@locals = {}			# hash of local game objects by ID number
	end

	# Add an event to the queue. All events in the queue will be processed
	# at the next #flush call.
	def tell(ev)
		@queue << ev
	end

	# Iterate through all events in the queue, and deliver them to
	# their corresponding game objects
	# 
	# Additionally if the event describes a local object (i.e. the event
	# originated from this client), it is sent to remote clients across the
	# network.
	# 
	# The queue is emptied after all events are delivered.
	def flush
		@queue.each do |ev|
			if local?(ev.object)
				push_network(ev)
			end
			deliver(ev)
		end
		@queue = []
	end

	# Deliver the given game event to its corresponding game object.
	def deliver(ev)
		begin
			lookup(ev.object).tell(ev)
		rescue NoMethodError
			puts "Netman: I don't know of a game object with ID: #{ev.object}"
		end
	end

	# Return a reference to the game object corresponding to the given
	# ID number.
	def lookup(id)
		@objects[id]
	end

	# Return true if the object corresponding to the given ID number is
	# controlled locally on this machine.
	def local?(id)
		@locals[id] != nil
	end

	# Send the event to remote clients across the network.
	def put_network
	end
end
