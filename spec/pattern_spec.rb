require 'rspec'
require_relative '../src/pattern'
require_relative '../src/generator'
require_relative '../src/library'

RSpec.describe Pattern do
	before do
		level :blue
			category :gender
				trait :male
		level :purple
			category :nationality
				trait :eastern_bloc
		pattern :blue, :gender, :male, name: :basic
		pattern :basic, :purple, weight: :very_often
	end

	after do
		clear
	end

	describe "@elements" do
		it "imports level, category, and trait symbols" do
			p = Generator.patterns.first
			expect(p.elements).to contain_exactly(:blue, :gender, :male)
		end

		it "replaces pattern names with their elements" do
			p = Generator.patterns.last
			expect(p.elements).to contain_exactly(:blue, :gender, :male, :purple)
		end

		it "raises an error when referencing a name belonging to two patterns" do
			pattern :blue, name: :basic
			expect {pattern :basic}.to raise_error
		end

		it "raises an error when referencing a name not belonging to any pattern, level, category, or trait" do
			expect {pattern :unknown_pattern}.to raise_error
		end
	end

	describe "@name" do
		it "defines a @name attribute" do
			expect(Pattern.new(name: :test).name).to eq(:test)
		end
	end

	describe "@weight" do
		it "defines a @weight attribute" do
			expect(Pattern.new(weight: :often).weight).to eq(:often)
		end

		it "uses @weight = :average when no weight specified" do
			p = Generator.patterns.first
			expect(p.weight).to eq(:average)
		end

		it "uses @weight = :average when unknown weight specified" do
			pattern :blue, weight: :dude
			p = Generator.patterns.last
			expect(p.weight).to eq(:average)
		end

		it "uses @weight = :never if @ appears is set to 0" do
			expect(Pattern.new(appears: 0).weight).to eq(:never)
		end

	end

	describe "@appears" do
		it "defines an @appears attribute" do
			expect(Pattern.new(appears: 1).appears).to eq(1)
		end

		it "uses @appears = nil when non integer appears is specified" do
			expect(Pattern.new(appears: 'once').appears).to be_nil
		end

		it "uses @appears = nil when appears is not specified" do
			expect(Pattern.new(:blue).appears).to be_nil
		end
	end

	it "has a well defined #to_s method" do
		p = Generator.patterns.first
		expect(p.to_s).to eq("PATTERN:: Elements: [:blue, :gender, :male]; Name: basic; Weight: average")
	end
end
