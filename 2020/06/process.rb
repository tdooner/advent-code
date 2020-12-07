require 'set'

def count_part_1(group)
  Set.new(group.split("\n").flat_map do |item|
    item.each_char.to_a
  end).to_a.length
end

def count_part_2(group)
  answers = group.split("\n").map(&:strip)
  current_intersection = Set.new(answers.shift.each_char)
  while answers.length > 0
    current_intersection &= answers.shift.each_char
  end
  current_intersection.length
end

input = File.read(ARGV[0]).split("\n\n").map(&:strip)

puts 'Part 1:'
puts input.map { |group| count_part_1(group) }.to_a.sum

puts 'Part 2:'
puts input.map { |group| count_part_2(group) }.to_a.sum
