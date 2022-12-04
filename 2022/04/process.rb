require 'pry'
def copy(value); return if value.nil?; `/bin/bash -c 'echo -n "#{value}" | pbcopy'`; "#{value}    <- COPIED TO CLIPBOARD" end

def parse(input)
  input.split("\n").map { |l| l.split(',') }
end

def part1(parsed)
  parsed.count do |one, two|
    a,b = one.split('-').map(&:to_i)
    c,d = two.split('-').map(&:to_i)

    (a..b).cover?(c..d) || (c..d).cover?(a..b)
  end
end

def part2(parsed)
  parsed.count do |one, two|
    a,b = one.split('-').map(&:to_i)
    c,d = two.split('-').map(&:to_i)

    ((a..b).to_a & (c..d).to_a).any?
  end
end

parsed = parse(ARGF.read.chomp)

puts "Part 1:"
puts copy(part1(parsed))

puts
puts "Part 2:"
puts copy(part2(parsed))
