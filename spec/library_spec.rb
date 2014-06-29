require 'rspec'
require_relative '../src/library'
require_relative '../src/set_dsl'

RSpec.describe Library do
	before do
		level :blue
			category :gender
				trait :male
	end

	after do
		clear
	end

	describe "#trait?" do
		it "recognizes valid trait symbols" do
			expect(!!(Library.trait? :male)).to eq(true)
		end

		it "recognizes invalid trait symbols" do
			expect(!!(Library.trait? :dude)).to eq(false)
		end

		it "finds categories for traits" do
			expect(Library.trait? :male).to eq(:gender)
		end
	end
end
