input = ARGF.read

elves = input.split("\n\n").map { |i| i.each_line.map(&:to_i).sum }

puts "Part 1:"
puts elves.max

puts "Part 2:"
puts elves.sort.reverse.first(3).sum
