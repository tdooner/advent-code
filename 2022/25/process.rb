require 'bundler'; Bundler.require(:default)
def pbcopy(value); return if value.nil?; `/bin/bash -c 'echo -n "#{value}" | pbcopy'`; "#{value}    <- COPIED TO CLIPBOARD" end
def debug(&block); puts block.call if ENV['D'].present?; end

def parse(input)
  input.split("\n")
end

def snafu_to_int(snafu)
  snafu
    .tr('=\-012', "01234")
    .chars
    .reverse
    .each_with_index
    .sum { |c, i| (c.to_i - 2) * (5 ** i) }
end

def int_to_snafu(int)
  base_5 = [0] + int.to_s(5).chars.map(&:to_i)
  (base_5.length - 1).downto(1).each do |i|
    if base_5[i] > 2
      base_5[i] -= 5
      base_5[i - 1] += 1
    end
  end
  base_5.delete_at(0) if base_5[0] == 0
  base_5.map { |i| '=-012'[i + 2] }.join
end

def part1(parsed)
  total = parsed.sum do |line|
    snafu_to_int(line)
  end
  binding.pry

  int_to_snafu(total)
end

def part2(parsed)
end

input = ARGF.read.chomp
puts "PARSED: #{parse(input)}"

puts "Part 1:"
puts pbcopy(part1(parse(input)))

puts
puts "Part 2:"
puts pbcopy(part2(parse(input)))
