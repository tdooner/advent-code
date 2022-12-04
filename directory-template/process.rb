require 'pry'
def copy(value); return if value.nil?; `/bin/bash -c 'echo -n "#{value}" | pbcopy'`; "#{value}    <- COPIED TO CLIPBOARD" end

def parse(input)
  input
end

def part1(parsed)
end

def part2(parsed)
end

parsed = parse(ARGF.read.chomp)
puts "PARSED: #{parsed.inspect}"

puts "Part 1:"
puts copy(part1(parsed))

puts
puts "Part 2:"
puts copy(part2(parsed))
