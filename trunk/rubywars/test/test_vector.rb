#!/usr/bin/env ruby

# 2D vector class unit tests
# 
# This is one part of:
#
# Rubywars (working title) --  A scrolling space shooter game
# Copyright (C) Greg Colombo, John Croisant 2005

require '../src/vector'
require 'test/unit'

# Float representatiosn are inherently inaccurate, but precision accuracy
# is not necessary for this Vector class. If the output is accurate to 4
# decimals, that's good enough for us!

TOL = 0.0001 					# tolerance for assert_in_delta

class TC_Vector < Test::Unit::TestCase

	# --
	# INITIALIZATION (X|Y)
	# ++

	# Initialize a Vector with integer X/Y components.
	def test_init_xy_int
		v = Vector.new(3,5)
		assert_in_delta(3, v.x, TOL)
		assert_in_delta(5, v.y, TOL)
	end

	# Initialize a Vector with floating-point X/Y components.
	def test_init_xy_float
		v = Vector.new(3.1,5.2)
		assert_in_delta(3.1, v.x, TOL)
		assert_in_delta(5.2, v.y, TOL)
	end

	# Initialize a Vector with negative X/Y components.
	def test_init_xy_neg
		v = Vector.new(-3,-5)
		assert_in_delta(-3, v.x, TOL)
		assert_in_delta(-5, v.y, TOL)
	end

	# Initialize a Vector with X/Y components of zero.
	def test_init_xy_zero
		v = Vector.new(0,0)
		assert_in_delta(0, v.x, TOL)
		assert_in_delta(0, v.y, TOL)
	end



	# Initialize a Vector with integer X/Y components in an
	# Array.
	def test_init_xy_int_ary
		v = Vector.new([3,5])
		assert_in_delta(3, v.x, TOL)
		assert_in_delta(5, v.y, TOL)
	end

	# Initialize a Vector with floating-point X/Y components in
	# an Array.
	def test_init_xy_float_ary
		v = Vector.new([3.1,5.2])
		assert_in_delta(3.1, v.x, TOL)
		assert_in_delta(5.2, v.y, TOL)
	end

	# Initialize a Vector with negative X/Y components in an Array.
	def test_init_xy_neg_ary
		v = Vector.new([-3,-5])
		assert_in_delta(-3, v.x, TOL)
		assert_in_delta(-5, v.y, TOL)
	end

	# Initialize a Vector with X/Y components of zero in an Array.
	def test_init_xy_zero_ary
		v = Vector.new([0,0])
		assert_in_delta(0, v.x, TOL)
		assert_in_delta(0, v.y, TOL)
	end


	# --
	# INITIALIZATION (A|M)
	# ++

	# Initialize (A|M) a Vector with integer angle and magnitude.
	def test_init_am_int
		v = Vector.new_am(2,3)
		assert_in_delta(-1.24844, v.x, TOL)
		assert_in_delta( 2.72789, v.y, TOL)
	end

	# Initialize (A|M) a Vector with floating-point angle and magnitude.
	def test_init_am_float
		v = Vector.new_am(4.71239,2.5)
		assert_in_delta( 0.0, v.x, TOL)
		assert_in_delta(-2.5, v.y, TOL)
	end

	# Initialize (A|M) a Vector with negative angle and magnitude.
	def test_init_am_neg
		v = Vector.new_am(-PI/4,-4)
		assert_in_delta(-2.82843, v.x, TOL)
		assert_in_delta( 2.82843, v.y, TOL)
	end

	# Initialize (A|M) a Vector with an angle and magnitude of zero.
	def test_init_am_zero
		v = Vector.new_am(0,0)
		assert_in_delta(0, v.x, TOL)
		assert_in_delta(0, v.y, TOL)
	end



	# Initialize (A|M) a Vector with integer angle and magnitude in
	# an Array.
	def test_init_am_int_ary
		v = Vector.new_am([2,3])
		assert_in_delta(-1.24844, v.x, TOL)
		assert_in_delta( 2.72789, v.y, TOL)
	end

	# Initialize (A|M) a Vector with floating-point angle and magnitude
	# in an Array.
	def test_init_am_float_ary
		v = Vector.new_am([4.71239,2.5])
		assert_in_delta( 0.0, v.x, TOL)
		assert_in_delta(-2.5, v.y, TOL)
	end

	# Initialize (A|M) a Vector with negative angle and magnitude in
	# an Array.
	def test_init_am_neg_ary
		v = Vector.new_am([-PI/4,-4])
		assert_in_delta(-2.82843, v.x, TOL)
		assert_in_delta( 2.82843, v.y, TOL)
	end

	# Initialize (A|M) a Vector with an angle and magnitude of zero
	# in an Array.
	def test_init_am_zero_ary
		v = Vector.new_am([0,0])
		assert_in_delta(0, v.x, TOL)
		assert_in_delta(0, v.y, TOL)
	end


	# --
	# TO_S and INSPECT
	# ++

	# Examine the output of Vector#to_s when x and y are integers.
	def test_to_s_int
		v = Vector.new(3,5)
		assert_equal("#<Vector: 3, 5>",v.to_s)
	end

	# Examine the output of Vector#to_s when x and y are floats.
	def test_to_s_float
		v = Vector.new(3.1,5.2)
		assert_equal("#<Vector: 3.1, 5.2>",v.to_s)
	end



	# Examine the output of Vector#inspect when x and y are integers.
	def test_inspect_int
		v = Vector.new(3,5)
		assert_equal("#<Vector:#{v.object_id}: 3, 5>",v.inspect)
	end

	# Examine the output of Vector#inspect when x and y are floats.
	def test_inspect_float
		v = Vector.new(3.1,5.2)
		assert_equal("#<Vector:#{v.object_id}: 3.1, 5.2>",v.inspect)
	end


	# --
	# EQUALITY
	# ++

	# Compare equality of two Vectors.
	def test_equal_vector
		v = Vector.new(3,5)
		v2 = Vector.new(3,5)
		assert_equal(v,v2)
	end

	# Compare equality of a Vector and a corresponding Array.
	def test_equal_array
		v = Vector.new(3,5)
		a = [3,5]
		assert_equal(v,a)
	end


	# --
	# VECTOR ARITHMETIC
	# ++

	# Test addition of two Vectors.
	def test_add_vector
		v = Vector.new(3,5) + Vector.new(1,4)
		assert_in_delta(4, v.x, TOL)
		assert_in_delta(9, v.y, TOL)
	end

	# Test subtraction of two Vectors.
	def test_subtract_vector
		v = Vector.new(3,5) - Vector.new(1,4)
		assert_in_delta(2, v.x, TOL)
		assert_in_delta(1, v.y, TOL)
	end

	# Test multiplication of two Vectors. This behavior differs
	# from 'standard' vector behavior.
	def test_multiply_vector
		v = Vector.new(3,5) * Vector.new(1,4)
		assert_in_delta( 3, v.x, TOL)
		assert_in_delta(20, v.y, TOL)
	end

	# Test division of two Vectors. This behavior differs from
	# 'standard' vector behavior.
	def test_divide_vector
		v = Vector.new(3,5) / Vector.new(1,4)
		assert_in_delta(3.00, v.x, TOL)
		assert_in_delta(1.25, v.y, TOL)
	end


	# --
	# SCALAR ARITHMETIC
	# ++

	# ...
end

#	# Create some test vectors.
#	a = Vector.new(1,2)
#	b = Vector.new(3,4)
#	c = Vector.new(-1,-2)
#	d = Vector.new(0,0)
#	unit = Vector.new(1,0)

# 	# Test basic arithmetic functionality with constants
# 	# Passed this test 6/11/2005
# 	puts 'Testing vector + constant'
# 	z = a + n
# 	puts z.inspect, ' Expected: <6, 7> '
# 	z = a - n
# 	puts z.inspect, ' Expected: <-4, -3> '
# 	z = a * n
# 	puts z.inspect, ' Expected: <5, 10> '
# 	z = a / n
# 	puts z.inspect, ' Expected: <.2, .4> '
# 	puts "\n"

# 	# Test vector/vector arithmetic
# 	# Test passed on 6/11/2005
# 	puts 'Testing vector + vector'
# 	z = a + b
# 	puts z.inspect, ' Expected: <4, 6> '
# 	z = a - b
# 	puts z.inspect, ' Expected: <-2, -2>'
# 	z = a * b
# 	puts z.inspect, ' Expected: <3, 8>'
# 	z = a / b
# 	puts z.inspect, ' Expected: <.333, .5>'
# 	puts "\n"

# 	# Test action of the zero vector
# 	# Test passed on 6/11/2005
# 	puts 'Testing vector + 0'
# 	z = a + d
# 	puts z.inspect, ' Expected: <1, 2> '
# 	z = a - d
# 	puts z.inspect, ' Expected: <1, 2> '
# 	z = a * d
# 	puts z.inspect, ' Expected: <0, 0> '
# 	puts "\n"

# 	# Test some of the advanced vector functions
# 	# Tests passed 6/11/2005
# 	puts 'Testing advanced functions'
# 	z = unit.tangent
# 	puts z.inspect, ' Expected: <0, 1> '
# 	z = b.magnitude
# 	puts z.inspect, ' Expected: 5'
# 	z = unit.tangent.angle
# 	puts z.inspect, ' Expected: pi/2 '
# 	z = a.dot(b)
# 	puts z.inspect, ' Expected: 11 '
# 	z = unit.angle_with?(unit.tangent)
# 	puts z.inspect, ' Expected: pi/2 '
# 	z = vector_from_to(a,b)
# 	puts z.inspect, ' Expected: <2, 2> '
# 	puts "\n"

# 	# Test direct modification of properties
# 	puts 'Testing direct property modification'
# 	z = unit
# 	z.magnitude = 4
# 	puts z.inspect, ' Expected: <4, 0> '
# 	z.normal = Vector.new(0,1)
# 	puts z.inspect, ' Expected: <0, 4> '
# 	z.x = 4
# 	z.y = 16
# 	puts z.inspect, ' Expected: <4, 16> '
# 	z = Vector.new(1,0)
# 	z.angle = Math::PI
# 	puts z.inspect

