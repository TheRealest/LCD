require_relative 'debuggable'
require_relative 'library'
require_relative 'pattern'

module Generator
	class << self
		attr_reader :patterns, :rng, :category_tree, :level_tree
	end
	extend Debug

	@rng = Random.new
	@patterns = []
	@set = ""
	@weight_keywords = {
		:very_often => 50,
		:often => 20,
		:average => 10,
		:rarely => 5,
		:very_rarely => 2,
		:never => 0
	}

	def self.clear
		@patterns.clear
	end

	# Helper methods for building character set via DSL
	def self.use_seed seed
		# converts String seed to alphanumeric only no spaces, then to int as a base
		# 36 number, and uses it as the RNG seed
		@rng = Random.new(seed.gsub(/[^0-9a-zA-Z]/,'').to_i(36))
		@set = seed
	end

	def self.create_pattern *args
		@patterns << Pattern.new(*args)
	end

	def self.last_pattern
		@patterns.last
	end

	# Attribute getter
	def self.weight_value key
		@weight_keywords.fetch(key) {raise ArgumentError, "Invalid weight keyword: :%s" % key}
	end

	# Validation methods
	def self.weight_keyword? key
		@weight_keywords.include? key
	end

	def self.pattern? pattern
		@patterns.select { |pat| return pat if pat.name == pattern }
	end

	# Generate characters
	def self.generate n
		Generator.create_trait_tree
		ordered_traits = Generator.tree_values Generator.level_tree
		n = n.to_i unless n.is_a? Integer
		n.times do |count|
			p = Generator.wrand
			traits = []
			p.elements.each do |elem|
				if Generator.level_tree.include? elem
					available = Generator.level_tree[elem]
				elsif Generator.category_tree.include? elem
					available = Generator.category_tree[elem]
				else
					available = [elem]
				end

				# Now remove traits from overlapping cateogries
				overlap = traits.inject([]) do |list,tr|
					list + Library.traits[Library.trait? tr]
				end
				available -= overlap

				# TODO: use "Generator.wrand available" with Trait objects w/ @weight
				traits << Generator.erand(available)
			end
			traits.sort! do |a,b|
				ordered_traits.index(a) <=> ordered_traits.index(b)
			end
			Library.add_character "#{@set}-#{count+1}", *traits
			Generator.dputs Library.last_character
		end
	end

	def self.create_trait_tree
		@category_tree = Library.traits.dup
		@level_tree = Library.levels.inject({}) { |tree,lvl|
			tree.merge lvl.first => lvl.last.inject([]) { |list,cat|
				list << @category_tree[cat]
			}.flatten
		}
	end

	# Gives flat list of all leaf elements of a nested hash
	def self.tree_values hash
		new_hash = hash.collect do |k,v|
			if v.is_a? Hash
				tree_values v
			else
				v
			end
		end
		new_hash.flatten
	end

	def self.wrand ary=nil
		ary ||= @patterns
		raise IndexError, "Cannot use #wrand on an empty array" if ary.size == 0
		raise TypeError, "Argument for #wrand must be an array" unless ary.is_a? Array
		total = ary.inject(0) {|sum,elem| sum + Generator.weight_value(elem.weight)}
		guess = @rng.rand total

		ary.inject(0) do |sum, elem|
			w = Generator.weight_value(elem.weight)
			sum += w
			break elem if guess < sum
			sum
		end
	end

	def self.erand ary
		guess = @rng.rand ary.size
		ary[guess]
	end
end
