require 'pry'
def copy(value); return if value.nil?; `/bin/bash -c 'echo -n "#{value}" | pbcopy'`; "#{value}    <- COPIED TO CLIPBOARD" end

SCORES = (('a'..'z').to_a + ('A'..'Z').to_a).each_with_index.map { |a, i| [a, i + 1] }.to_h

def parse(input)
  input.split("\n")
end

def part1(parsed)
  score = 0
  parsed.each do |sack|
    left, right = [sack[0..sack.length / 2 - 1], sack[sack.length / 2..sack.length]]
    common = left.chars & right.chars
    score += common.sum { |chr| SCORES[chr] }
  end
  score
end

def part2(parsed)
  score = 0
  groups = parsed.each_slice(3)
  groups.each do |sacks|
    common = sacks[0].chars & sacks[1].chars & sacks[2].chars
    score += SCORES[common.first]
  end
  score
end

parsed = parse(ARGF.read.chomp)

puts "Part 1:"
puts copy(part1(parsed))

puts
puts "Part 2:"
puts copy(part2(parsed))
