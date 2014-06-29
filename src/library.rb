require_relative 'debuggable'
require_relative 'character'

module Library
	class << self
		attr_reader :traits, :levels, :characters
	end
	extend Debug

	@traits = {}
	@levels = {}
	@characters = []

	def self.clear
		@traits.clear
		@levels.clear
		@characters.clear
	end

	def self.clear_characters
		@characters.clear
	end

	# Helper methods for building trait library via DSL
	def self.add_level level
		@levels.update level => []
		@last_level = level
	end

	def self.update_last_level cat
		@levels[@last_level] << cat unless @levels[@last_level].include? cat
	end

	def self.add_category cat
		@traits.update cat => []
		@last_cat = cat
	end

	def self.update_last_cat trait
		@traits[@last_cat] << trait unless @traits[@last_cat].include? trait
	end

	def self.add_character name, *traits
		@characters << Character.new(name, traits)
	end

	def self.last_character
		@characters.last
	end

	# Validation methods
	def self.trait? trait
		@traits.each do |cat, list|
			return cat if list.include? trait
		end
		false
	end

	def self.category? cat
		@levels.each do |level, list|
			return level if list.include? cat
		end
		false
	end

	def self.level? lvl
		@levels.include? lvl
	end

	def self.valid? elem
		!!Library.level?(elem) || !!Library.category?(elem) || !!Library.trait?(elem)
	end

end
