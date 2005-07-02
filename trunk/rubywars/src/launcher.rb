# Launcher file
#
# This is one part of:
#
# Rubywars (working title) --  A scrolling space shooter game
# Copyright (C) Greg Colombo, John Croisant 2005
#
# "NFL Sunday Ticket / This is how watching football games should be / It's NFL Sunday Ticket / on DirecTV"

require 'src/vector'

class Launcher

	def initialize(parent, type, spawnedLifespan)
		@parent = parent
		@type = type
		@lifespan = spawnedLifespan
	end

        def shoot
                t = (Rubygame::Time.get_ticks() - @parent.stamp[:p])/1000.0
                v = Vector.new(1,0).rotate(@parent.angle)
                v.magnitude += 150
                p = @parent.project(t)
                @groups[0].push(@type.new(p,v,lifespan))
        end

end
