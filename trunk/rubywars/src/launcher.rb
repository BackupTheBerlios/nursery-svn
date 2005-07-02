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

	def initialize(parent)
		@parent = parent
	end

        def shoot
                t = (Rubygame::Time.get_ticks() - @parent.stamp[:p])/1000.0
                v = Vector.new(1,0).rotate(@parent.angle)
                v.magnitude += 150
                p = @parent.project(t)
                @groups[0].push(Bullet.new(p,v,1000))
        end

end
