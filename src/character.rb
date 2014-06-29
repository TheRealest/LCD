# Imports
require_relative 'library'
require_relative 'collection'

class Character
	attr_reader :name, :traits

	def initialize name, *traits
		@name = name.is_a?(String) ? name : (nil or raise ArgumentError, "Character name must be a string")

		@traits = {}
		traits.flatten!
		traits.each do |trait|
			cat = Library.trait? trait
			raise ArgumentError, "Cannot have two traits (#{trait}, #{@traits[cat]}) of the same category (#{cat})" if @traits.has_key? cat

			@traits[cat] = trait
		end
	end

	def has_trait? trait
		cat = Library.trait? trait
		@traits.has_key? cat and @traits[cat] == trait
	end

	def find_matches other
		raise TypeError, "Method Character.find_matches should only be used on another Character" if !other.is_a? Character
		matches = []
		@traits.each do |cat, tr|
			matches << tr if other.has_trait? tr
		end
		matches.empty? ? [] : matches
	end

	def matches_trait? trait
		raise TypeError, "Method Character.matches_trait? should only be used on a valid trait symbol" unless trait.is_a? Symbol and Library.trait? trait
		has_trait?(trait) ? [trait] : []
	end

	def matches_traits? traits
		error_message = "Method Character.matches_traits? should only be used on an array of valid trait symbols"
		raise TypeError, error_message unless traits.is_a? Array and !traits.empty?
		traits.each do |trait|
			raise TypeError, error_message unless trait.is_a? Symbol and Library.trait? trait
		end
		traits = traits.map{|tr| matches_trait? tr}.flatten.compact
	end

	def to_s
		str = "CHARACTER:: "
		str += "Name: #{@name.to_s}"
		str += "; Traits: #{@traits}"
		str
	end

	def traits_to_s
		@traits.inject([]) do |list,elem|
			list << elem.last.to_s.gsub(/_/," ").split.map(&:capitalize).join(" ")
		end
	end

	def traits_to_s_with_level
		newlist = @traits.inject([]) do |list,elem|
			trait = elem.last
			level = Generator.level_tree.each do |lvl,trs|
				break lvl if trs.include? trait
			end
			list << [level, trait]
		end
		newlist.inject([]) do |list,elem|
			formatted_trait = elem.last.to_s.gsub(/_/," ").split.map(&:capitalize).join(" ")
			list << [elem.first, formatted_trait]
		end
	end

	# Operator ^ is a pseudo-"intersection" type operation which returns an array of
	# valid trait symbols shared between the two objects. A returned empty array
	# indicates no matching traits between the two objects, and a returned nil
	# indicates the second object is not of a valid comparable type.
	def ^ other
		if other.is_a? Character
			find_matches other
		elsif other.is_a? Collection
			other ^ self
		elsif other.is_a? Symbol
			matches_trait? other
		elsif other.is_a? Array
			matches_traits? other
		else
			nil
		end
	end

	def == other
		other.is_a?(Character) && @name == other.name && @traits == other.traits
	end
end
