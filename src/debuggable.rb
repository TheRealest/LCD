# == Mixin usage:
# [<tt>extend Debug</tt>]   Classes and Modules wanting to add debugging functionality as class methods
# [<tt>prepend Debug</tt>]  Classes wanting to add debugging to their instances (note this will not allow the class itself to use Debug)

module Debug
	def initialize *args		#:nodoc:
		@debuggable_status = false
		super *args
	end

	def self.extended base		#:nodoc:
		base.instance_eval {
			@debuggable_status = false
		}
	end

	# Sets debug status to the given status; calling without an argument turns on
	# debugging
	def debug status=true
		@debuggable_status = !!status
	end

	# Returns a boolean indicating whether debugging is currently active for the
	# caller
	def debug?
		!!@debuggable_status
	end

	# A debuggable version of +#puts+ -- delegates the given string to +#puts+ only
	# if debugging is active
	def dputs str=""
		puts str if debug?
	end
end