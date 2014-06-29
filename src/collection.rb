require_relative 'character'

class Collection
	attr_reader :elements, :traits
	@@min_expressed_trait_size = 3

	def initialize *elem
		@elements = elem.uniq
		update_traits
	end

	def update_traits
		if @elements.length == 0
			@traits = []
		elsif @elements.length == 1
			@traits = @elements[0] ^ @elements[0]
		else
			d = @elements.dup
			working = d.pop
			while d.length > 0
				elem = d.pop
				working = elem ^ working
			end
			@traits = working
		end
	end

	def << other
		@elements << other if (other.is_a? Character or other.is_a? Collection) and !@elements.include? other
		update_traits
	end

	def ^ other
		if other.is_a? Character
			other ^ @traits
		elsif other.is_a? Collection
			ar = @traits & other.traits
		elsif other.is_a? Symbol
			ar = [other] if @traits.include? other
			ar ||= []
		elsif other.is_a? Array
			ar = []
			other.each do |o|
				ar << (self ^ o)
			end
			ar.flatten.compact
		else
			nil
		end
	end
end