require_relative 'generator'
require_relative 'library'

class Pattern
	attr_reader :name, :weight, :appears, :elements

	def initialize *args
		params = args.pop if args[-1].is_a? Hash
		params ||= {}

		@name = params[:name]
		@appears = params[:appears].is_a?(Integer) ? params[:appears] : nil
		@weight = Generator.weight_keyword?(params[:weight]) ? params[:weight] : :average
		@weight = :never if @appears == 0
		@elements = args

		replace_pattern_elements
	end

	def to_s
		str = "PATTERN:: "
		str += "Elements: #{@elements.to_s}"
		str += "; Name: #{@name.to_s || ''}" unless @name.nil?
		str += "; Weight: #{@weight.to_s || ''}" unless @weight.nil?
		str += "; Appears: #{@appears.to_s || ''}" unless @appears.nil?
		str
	end

	def replace_pattern_elements
		@elements = @elements.inject [] do |list,elem|
			if Library.valid? elem
				list << elem
			else
				matches = Generator.patterns.select {|p| p.name == elem}
				raise ArgumentError, "Multiple patterns defined with the same name: #{elem}" if matches.size > 1
				raise ArgumentError, "No pattern, level, category, or trait defined for symbol: #{elem}" if matches.size < 1
				list + matches.first.elements
			end
		end
	end
				
end


