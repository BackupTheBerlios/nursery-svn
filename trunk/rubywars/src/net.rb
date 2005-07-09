# Networking system definitions
# 
# This is one part of:
#
# Rubywars (working title) --  A scrolling space shooter game
# Copyright (C) Greg Colombo, John Croisant 2005

require 'socket'
require 'src/game_event'

# Network overview:
# 
#  Sending events:
#    1. Hardware events occur (e.g. keyboard press)
#    2. Hardware event is translated into game event (e.g. ship1 accelerates)
#    3. Game event is passed to Netman
#    4. Game event is converted to a string
#    5. Netman sends string to other clients across the network.
#    6. Netman passes event to the game object it describes.
#    7. Game object uses event to update state.
# 
#  Receiving events:
#    1. Netman receives string from across network.
#    2. String is translated into game event.
#    3. Netman passes event to the game object it describes.
#    4. Game object uses event to update state.
# 

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
		@connects = []			# TCP connections with other clients
		@queue = []				# game events are stored here
		@objects = {}			# hash of game objects by identifier number
		@locals = {}			# hash of local game objects by ID number
	end

	# Deliver the given game event to its corresponding game object.
	def deliver(ev)
		begin
			lookup(ev.object).tell(ev)
		rescue NoMethodError
			puts "Netman: I don't know of a game object with ID: #{ev.object}"
		end
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

	# Generate a random integer in 0..10000. If an object with that
	# ID number exists, choose another random integer.
	def generate_object_id()
		(id = rand(10000)) until @objects[id] == nil
		return id
	end

	# Return true if the object corresponding to the given ID number is
	# controlled locally on this machine.
	def local?(id)
		@locals[id] != nil
	end

	# Return a reference to the game object corresponding to the given
	# ID number.
	def lookup(id)
		@objects[id]
	end

	# Make a TCP connection with the given Internet Protocol address and port
	def make_connect(address,port)
#		c = Connection.new()
		@connects << c
	end

	# Send the event to remote clients across the network.
	def put_network(ev)
		@connects.each do |c|
			c.puts(ev.to_net)
		end
	end

	# Register a locally-created object and send an event over the net.
	def register_local(obj)
		id = generate_id()
		@locals[id] = obj
		register_object(obj,id)
		put_network( NewObjectEvent(id,obj) )
	end

	# Register the given game object under the given integer ID
	def register_object(obj,id)
		unless @objects[id]
			@objects[id] = obj
		end
	end

	# Add an event to the queue. All events in the queue will be processed
	# at the next #flush call.
	def tell(ev)
		@queue << ev
	end
end
