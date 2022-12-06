require 'bundler'; Bundler.require(:default)
def pbcopy(value); return if value.nil?; `/bin/bash -c 'echo -n "#{value}" | pbcopy'`; "#{value}    <- COPIED TO CLIPBOARD" end

def parse(input)
  input.chars
end

def part1(parsed)
  parsed.each_cons(4).each_with_index { |slice, i| return 4+i if slice.uniq == slice }
end

def part2(parsed)
  parsed.each_cons(14).each_with_index { |slice, i| return 14+i if slice.uniq == slice }
end

parsed = parse(ARGF.read.chomp)

puts "Part 1:"
puts pbcopy(part1(parsed))

puts
puts "Part 2:"
puts pbcopy(part2(parsed))
