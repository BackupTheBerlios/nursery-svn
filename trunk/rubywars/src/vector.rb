# 2D vector class definition
# 
# This is one part of:
#
# Rubywars (working title) --  A scrolling space shooter game
# Copyright (C) Greg Colombo, John Croisant 2005

PI = Math::PI
HALF_PI = PI*0.5
THREE_HALF_PI = PI*1.5
TWO_PI = PI*2

# A 2D vector class with some potentially useful properties:
#   Vector(a,b) + Vector(c,d) = Vector(a+c,b+d)
#   Vector(a,b) + n = Vector(a+n,b+n)
# 
# (It works the same way with subraction, multiplication, and division.)
# 
# Vector is used for storing 2D coordinates +(x,y)+ as well as
# vectors such as velocity or acceleration (representationally,
# they are equivalent.)
# 
# When creating a Vector, you can specify either its x and y components,
# using the Vector.new() method, or its angle (radians) and magnitude,
# using the Vector.new_am() method.
# 
# Additionally, Vector contains functions for manipulating itself.
# You can both get and set such properties as #angle, #magnitude,
# and #normal, and the Vector will change as needed. For example,
# if you set #angle, the vector will change to have the new angle,
# but keeps the same magnitude as before.
# 
# Wherever a function takes an x and a y, they can either be
# given as seperate arguments, or as an Array (or Vector).
# Isn't that super-convenient?
# 
# This version is meant to save processing time by storing extra
# properties (angle, magnitude, etc.) whenever they are calculated,
# so that they only need to be calculated once. If the vector
# changes, the properties will be calculated again next time they
# are needed.
# 
# (This is an example of premature optimization. I really should
# have profiled this code first to see if storing the properties
# was an overall benefit or not. Let this be a lesson to YOU!)
# 
class Vector
	attr_reader :x, :y
	attr_writer :x, :y

	# Create a new Vector, specifying its x and y components.
	def initialize(x,y=nil)
		if y
			@x, @y = x, y
		else
			@x, @y = *x
		end
	end

	# Create a new Vector, specifying its angle (radians) and magnitude.
	def self.new_am(a,m=nil)
		v = Vector.new(0,0)
		if m
			v.a, v.m = a, m
		else
			v.a, v.m = *a
		end
		return v
	end

	def to_s
		"#<#{self.class}: #{@x}, #{@y}>"
	end

	def inspect
		"#<#{self.class}: #{@x}, #{@y}>"
	end

	def [](index)
		[@x,@y][index]
	end

	def +(other)
		self.class.new(@x+other[0],@y+other[1])
	end

	def -(other)
		self.class.new(@x-other[0],@y-other[1])
	end

	def *(other)
		if other.kind_of? Numeric
			return self.class.new(@x*other,@y*other)
		else
			return self.class.new(@x*other[0],@y*other[1])
		end
	end

	def /(other)
		x,y = @x.to_f,@y.to_f
		if other.kind_of? Numeric
			return self.class.new(x/other,y/other)
		else
			return self.class.new(x/other[0],y/other[1])
		end
	end

	def to_a
		[@x,@y]
	end

	def x=(v)
		if v.kind_of? Numeric and not @y.eql? v
			@x = v
			cleanUp()
		end
	end

	def y=(v)
		if v.kind_of? Numeric and not @y.eql? v 
			@y = v
			cleanUp()
		end
	end

	# Modify the x and y components of the Vector in-place
	def set!(x,y=nil)
		if y or (x.is_a? Array)
			@x, @y = *x
		else
			@x, @y = x, y
		end
		cleanUp()
	end

	# Modify the angle and magnitude of the Vector in-place
	def set_am!(a,m=nil)
		if m or (a.is_a? Array)
			self.a, self.m = *a
		else
			self.a, self.m = a, m
		end
		cleanUp()
	end

	#Returns the magnitude of self
	def magnitude
		@magnitude or @magnitude = Math.hypot(@x,@y)
	end
	#Modifies the magnitude of self, preserving angle.
	def magnitude=(m)
		new = self.normal * m
		@x, @y = new.x, new.y
		self.cleanUp
	end
	alias m magnitude
	alias m= magnitude=

	#Return a version of self with a magnitude of 1
	def normal
		m = self.magnitude.to_f
		@normal or @normal = self.class.new(@x/m, @y/m)
	end

	#Modifies self to be like the given vector, but with self's old magnitude
	#Accepts 1 argument (a Vector, Array, or similar) or 2 (x and y parts)
	def normal=(nx,ny=nil)
		m = self.magnitude
		if ny
			n = Vector.new(n_or_nx,ny).normal
		elsif nx.is_a? Vector
			n = n_or_nx.normal
		else
			n = Vector.new(n_or_nx).normal
		end
		@x, @y = n[0]*m, n[1]*m
		cleanUp()
	end
	alias n normal
	alias n= normal=

	#Return a version of self, rotated pi/2 radians counter clock-wise
	def tangent
		@tangent or @tangent = self.class.new(-@y, @x)
	end
	def tangent=(tx,ty=nil)
		if ty
			@x, @y = -ty, tx
		else
			@x, @y = -tx[1], tx[0]
		end
		cleanUp()
	end
	alias t tangent
	alias t= tangent=

	#Return the angle (radians) the vector forms with the positive X axis
	def angle
		@angle or @angle = Math.atan2(@x,@y)
	end
	#Set the angle (radians) of the vector from the positive X axis.
	#Magnitude is preserved.
	def angle=(a)
		m = self.magnitude
		@x, @y = Math.cos(a)*m, Math.sin(a)*m
		cleanUp()
	end
	alias a angle
	alias a= angle=

	#Return the dot product for self and another vector
	def dot(other)
		@x*other.x + @y*other.y
	end
	#Return the dot product of normalized versions of self and another vector
	def ndot(other)
		sn = self.normal
		on = other.normal
		sn.x*on.x + sn.y*on.y
	end

	#Return the angle (radians) between self and another vector
	def angle_with?(other)
		Math.acos( self.ndot(other) )
	end

	def align!(other)
		self.normal = other
	end

	def rotate!(radians)
		case(radians)
		#Special cases for half-pi increments
		when HALF_PI, -THREE_HALF_PI
			self.set!(@y,-@x)
		when THREE_HALF_PI, HALF_PI
			self.set!(-@y,@x)
		when PI, -PI
			self.set!(@y,-@x)
		when 0, TWO_PI
			self.set!(@y,-@x)
		#General case
		else
			self.a += radians
		end
		return self
	end

	def rotate(radians)
		self.dup.rotate!(radians)
	end

	#Refreshes magnitude, normal, perp, and angle. For internal use only.
	def cleanUp
		@magnitude = nil
		@normal = nil
		@tangent = nil
		@angle = nil
		return self
	end
	private :cleanUp
end

# Calculate a vector connecting two points
def vector_from_to(p1,p2)
	begin
		Vector(p1-p2)
	rescue TypeError
		Vector(p1[0]-p2[0],p1[1]-p2[1])
	end
end
