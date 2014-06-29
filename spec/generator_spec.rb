require 'rspec'
require_relative '../src/set_dsl'
require_relative '../src/character'

RSpec.describe Generator do
	before do
		level :blue
			category :gender
				trait :male
				trait :female
				trait :mechanical
			category :age
				trait :teen
				trait :adult
				trait :old
		level :purple
			category :nationality
				trait :eastern_bloc
				trait :western_bloc
				trait :non_aligned
			category :religion
				trait :atheism
				trait :christianity
				trait :islam		
		pattern :blue, :blue, name: :basic
		pattern :blue, :purple
		pattern :basic, :purple, weight: :rarely
	end

	after do
		clear
	end

	it "uses strings as RNG seeds" do
		seed = "Hello World!"

		set seed
		x = Generator.rng.rand

		set seed
		y = Generator.rng.rand

		expect(x).to eq(y)
	end

	describe "#generate" do
		it "creates the proper number of characters" do
			Generator.generate 10
			expect(Library.characters.size).to eq(10)
			Library.clear_characters
		end

		it "creates Character objects" do
			Generator.generate 1
			expect(Library.characters.first).to be_a(Character)
			Library.clear_characters
		end

		it "deterministically generates Characters" do
			Generator.use_seed "generate test"
			Generator.generate 5
			first_run = Library.characters.dup

			Library.clear_characters

			Generator.use_seed "generate test"
			Generator.generate 5
			second_run = Library.characters.dup

			expect(first_run).to eq(second_run)
		end
	end

	describe "#create_trait_tree" do
		it "creates a trait tree organized by level in @level_tree" do
			Generator.create_trait_tree
			expect(Generator.level_tree).to eq({
				:blue => 
					[:male, :female, :mechanical, :teen, :adult, :old],
				:purple => 
					[:eastern_bloc, :western_bloc, :non_aligned, :atheism, :christianity, :islam]
				})
		end

		it "creates a trait tree organized by category in @category_tree" do
			Generator.create_trait_tree
			expect(Generator.category_tree).to eq({
				:gender => 
					[:male, :female, :mechanical],
				:age => 
					[:teen, :adult, :old],
				:nationality => 
					[:eastern_bloc, :western_bloc, :non_aligned],
				:religion => 
					[:atheism, :christianity, :islam]
				})
		end
	end

	describe "#tree_values" do
		it "creates flat array from deepest leaf elements of nested hash" do
			h = {
				:one => {
					:a => [1,2,3],
					:b => [4,5]
				},
				:two => [6,7,8],
				:three => 9
			}
			expect(Generator.tree_values h).to eq([1,2,3,4,5,6,7,8,9])
		end
	end

	describe "#erand" do
		it "randomly chooses an element from the given array" do
			Generator.use_seed "erand test"
			expect(Generator.erand [:a,:b,:c]).to eq(:a)
			expect(Generator.erand [:a,:b,:c]).to eq(:a)
			expect(Generator.erand [:a,:b,:c]).to eq(:b)
		end
	end

	describe "#wrand" do
		it "randomly (weighted) chooses an element with a valid weight attribute from an array" do
			a1 = double(weight: :"average")
			a2 = double(weight: :"average")
			vo = double(weight: :very_often)

			Generator.use_seed "wrand test"
			expect(Generator.wrand [a1,a2,vo]).to eq(vo) #69
			expect(Generator.wrand [vo,a1,a2]).to eq(a1) #51
		end

		it "raises an IndexError if given array is empty" do
			expect{Generator.wrand []}.to raise_error(IndexError)
		end

		it "raises a TypeError if argument is not an array" do
			expect{Generator.wrand 0}.to raise_error TypeError
			expect{Generator.wrand :a => 1}.to raise_error TypeError
			expect{Generator.wrand "hey"}.to raise_error TypeError
		end
	end



end
