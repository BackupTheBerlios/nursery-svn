# Rocket event definitions
# 
# This is one part of:
#
# Rubywars (working title) --  A scrolling space shooter game
# Copyright (C) Greg Colombo, John Croisant 2005

require 'src/events.rb'

class ThrustACWEvent     < GenericEvent; end
class StopThrustACWEvent < GenericEvent; end
class ThrustCWEvent      < GenericEvent; end
class StopThrustCWEvent  < GenericEvent; end
class ThrustAftEvent     < GenericEvent; end
class StopThrustAftEvent < GenericEvent; end
