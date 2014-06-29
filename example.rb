# Clears the terminal window
# puts "\e[H\e[2J"

# Imports
require_relative 'src/library'
require_relative 'src/character'
require_relative 'src/collection'

require_relative 'sets/cold_war.set'
puts

puts "Testing Character creation:"
c1 = Character.new "Joe", :male, :adult
c2 = Character.new "Bernie", :female, :adult
c3 = Character.new "Sarah", :female, :teen
c4 = Character.new "Alex", :spy, :adult, :male
p c1, c2, c3, c4

l1 = Collection.new c1
l2 = Collection.new c2
l3 = Collection.new c3

c = [c1,c2,c3,c4]
c.each do |x|
	puts "#{x.name} ^ #{c1.name} = #{x ^ c1 }"
end

puts
puts "Testing ^ operator for Character and Collection -- should return: \n[nil, [:adult], [], [:adult, :male], [], [:adult], [], [:adult], [], [:male, :adult], [:male, :adult]]"
p [c1 ^ 0, c1 ^ :adult, c1 ^ :spy, c1 ^ [:adult, :female, :male], c1 ^ [:female], c1 ^ c2, c1 ^ c3, c1 ^ l2, c1 ^ l3, c1 ^ l1, c1 ^ c1]
p [l1 ^ 0, l1 ^ :adult, l1 ^ :spy, l1 ^ [:adult, :female, :male], l1 ^ [:female], l1 ^ c2, l1 ^ c3, l1 ^ l2, l1 ^ l3, l1 ^ c1, l1 ^ l1]

puts "Testing commutativity of ^:"
puts "#{l1 ^ c4} = #{c4 ^ l1}"
puts "#{c1 ^ c4} = #{c4 ^ c1}"
puts "#{c1 ^ c1} = #{c1 ^ c1}"
puts
puts "Testing Library.valid?:"
puts ":blue? %s" % [Library.valid?(:blue)]
puts ":gender? %s" % [Library.valid?(:gender)]
puts ":male? %s" % [Library.valid?(:male)]
puts ":dude? %s" % [Library.valid?(:dude)]





