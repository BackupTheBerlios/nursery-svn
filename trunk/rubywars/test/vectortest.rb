# This is a unit test file for working with Vector.rb.

require 'vector'

# Main program body

def main
	# Create some test vectors.
	a = Vector.new(1,2)
	b = Vector.new(3,4)
	c = Vector.new(-1,-2)
	d = Vector.new(0,0)
	unit = Vector.new(1,0)
	n = 5

	# Verify that these vectors do, in fact, contain stuff
	puts a.inspect
	puts b.inspect
	puts c.inspect
	puts d.inspect
	puts n
	puts "\n"

	# Test basic arithmetic functionality with constants
	# Passed this test 6/11/2005
	puts 'Testing vector + constant'
	z = a + n
	puts z.inspect, ' Expected: <6, 7> '
	z = a - n
	puts z.inspect, ' Expected: <-4, -3> '
	z = a * n
	puts z.inspect, ' Expected: <5, 10> '
	z = a / n
	puts z.inspect, ' Expected: <.2, .4> '
	puts "\n"

	# Test vector/vector arithmetic
	# Test passed on 6/11/2005
	puts 'Testing vector + vector'
	z = a + b
	puts z.inspect, ' Expected: <4, 6> '
	z = a - b
	puts z.inspect, ' Expected: <-2, -2>'
	z = a * b
	puts z.inspect, ' Expected: <3, 8>'
	z = a / b
	puts z.inspect, ' Expected: <.333, .5>'
	puts "\n"

	# Test action of the zero vector
	# Test passed on 6/11/2005
	puts 'Testing vector + 0'
	z = a + d
	puts z.inspect, ' Expected: <1, 2> '
	z = a - d
	puts z.inspect, ' Expected: <1, 2> '
	z = a * d
	puts z.inspect, ' Expected: <0, 0> '
	puts "\n"

	# Test some of the advanced vector functions
	# Tests passed 6/11/2005
	puts 'Testing advanced functions'
	z = unit.tangent
	puts z.inspect, ' Expected: <0, 1> '
	z = b.magnitude
	puts z.inspect, ' Expected: 5'
	z = unit.tangent.angle
	puts z.inspect, ' Expected: pi/2 '
	z = a.dot(b)
	puts z.inspect, ' Expected: 11 '
	z = unit.angle_with?(unit.tangent)
	puts z.inspect, ' Expected: pi/2 '
	z = vector_from_to(a,b)
	puts z.inspect, ' Expected: <2, 2> '
	puts "\n"

	# Test direct modification of properties
	puts 'Testing direct property modification'
	z = unit
	z.magnitude = 4
	puts z.inspect, ' Expected: <4, 0> '
	z.normal = Vector.new(0,1)
	puts z.inspect, ' Expected: <0, 4> '
	z.x = 4
	z.y = 16
	puts z.inspect, ' Expected: <4, 16> '
	z = Vector.new(1,0)
	z.angle = Math::PI
	puts z.inspect
end

if $0 == __FILE__
        main()
end

