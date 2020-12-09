def process_line(line)
  line.strip.to_i
end

def solve(input)
  input.each_with_index.find do |num, i|
    next if i < 25

    input[(i - 25)..i]
      .combination(2)
      .none? { |n1, n2| n1 + n2 == num }
  end.first
end

def solve2(input, target)
  (2..input.length).each do |length|
    input.each_cons(length).find do |slice|
      next unless slice.sum == target
      return slice.min + slice.max
    end
  end
end

input = File.read(ARGV[0]).split(/\n/)
  .map { |l| process_line(l) }

puts 'Part 1:'
puts (part1 = solve(input))

puts 'Part 2:'
puts solve2(input, part1)
