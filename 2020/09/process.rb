def process_line(line)
  line.strip.to_i
end

def solve(input)
  preamble = input.first(25)
  input[25..-1].find do |num|
    invalid = preamble.combination(2).none? { |n1, n2| n1 + n2 == num }
    preamble.shift
    preamble.push(num)
    invalid
  end
end

def solve2(input, target)
  cons = 2
  found = nil
  while cons < input.length && !found
    found = input.each_cons(cons).find do |slice|
      slice.sum == target
    end
    cons += 1
  end

  found.min + found.max
end

input = File.read(ARGV[0]).split(/\n/)
  .map { |l| process_line(l) }

puts 'Part 1:'
part1 = solve(input)

puts 'Part 2:'
puts solve2(input, part1)
