def part1(input)
  chars = input.map(&:each_char).map(&:to_a)
  x = 3
  y = 1
  count = 0

  loop do
    count += 1 if chars[y][x % chars[0].length] == '#'

    x += 3
    y += 1
    break if y >= chars.length
  end

  count
end

def part2(input, slope_right, slope_down)
  chars = input.map(&:each_char).map(&:to_a)
  x = slope_right
  y = slope_down
  count = 0

  loop do
    count += 1 if chars[y][x % chars[0].length] == '#'

    x += slope_right
    y += slope_down
    break if y >= chars.length
  end

  count
end

input = File.read(ARGV[0] == '--test' ? 'test-input' : 'input').each_line.map(&:strip)

puts 'Part 1:'
puts part1(input)

puts 'Part 2:'
total_trees =
  part2(input, 1, 1) *
  part2(input, 3, 1) *
  part2(input, 5, 1) *
  part2(input, 7, 1) *
  part2(input, 1, 2)
puts total_trees
