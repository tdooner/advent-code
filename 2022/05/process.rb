require 'pry'
def copy(value); return if value.nil?; `/bin/bash -c 'echo -n "#{value}" | pbcopy'`; "#{value}    <- COPIED TO CLIPBOARD" end

def parse(input)
  header, commands = input.split("\n\n")
  indices = header.lines.last.gsub(/\d/).map { Regexp.last_match.begin(0) }
  crates = indices.map { |i| header.lines[0..-2].map { |l| l[i].strip } }

  {
    crates: crates.map { |c| c.keep_if { |i| i != "" } },
    commands: commands.split("\n").map { |l| m = l.match(/move (\d+) from (\d) to (\d)/); [m[1], m[2], m[3]].map(&:to_i) }
  }
end

def part1(parsed)
  crates = parsed[:crates].map(&:dup)
  parsed[:commands].each do |num, src, dest|
    num.times do
      crates[dest - 1].unshift(crates[src - 1].shift)
    end
  end

  crates.map(&:first).join
end

def part2(parsed)
  crates = parsed[:crates].map(&:dup)

  parsed[:commands].each do |num, src, dest|
    crates[dest - 1].unshift(*crates[src - 1].shift(num))
  end

  crates.map(&:first).join
end

parsed = parse(ARGF.read.chomp)

puts "Part 1:"
puts copy(part1(parsed.dup))

puts
puts "Part 2:"
puts copy(part2(parsed.dup))
