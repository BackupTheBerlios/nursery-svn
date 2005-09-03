# Image Bag class definitions
# 
# This is one part of:
#
# Rubywars (working title) --  A scrolling space shooter game
# Copyright (C) Greg Colombo, John Croisant 2005

require 'rubygame'


# Load image files and store them for future reference.
class ImageBag
	def initialize
		@images = {}
	end

	def load_image(path)
		Rubygame::Image.load(path)
	end

	# Return a Surface containing an image, loading an image file
	# if it has not yet been loaded. The image will be stored
	# the first time it is loaded.
	# 
	# If +key+ is associated with a string, this function will be called
	# using that value in the place of +key+.
	# 
	# If +key+ is associated with a Surface, that Surface will be returned.
	# 
	# If +key+ is not associated with anything (i.e. associated with +nil+),
	# +key+ is assumed to be a relative or absolute path to an image file.
	# The image file will be loaded, and +key+ will be associated with the
	# resulting Surface.
	# 
	# If the optional argument +force+ is true, the image file will
	# be (re)loaded, even if it has been loaded and stored before.
	def [](key,force=false)
		case @images[key]
		when Rubygame::Surface
			unless force
				return @images[key]
			else
				return @images[key] = load_image(path)
			end
		when String
			return self.[](@images[key])
		when nil
			return @images[key] = load_image(path)
		end
	end

	# Associate a key (e.g. String or Symbol) with a Surface or String.
	# 
	# If +value+ is a string, +key+ will act as an "alias" for +value+
	# in all future calls to #[]. When #[] is called with +key+, it will
	# be recursively called with +value+, and so on.
	# 
	# The old value associated with that key will be returned. This will be
	# +nil+ unless that key was already in use, in which case it will be either
	# a string (a file path), or a Surface (an image).
	def []=(key,value)
		@images[key] = value
	end

	# Return the value associated with +key+, but do not attempt to load
	# any image files or perform any recursive look-ups.
	def peek(key)
		return @images[key]
	end
end
