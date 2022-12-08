require 'bundler'; Bundler.require(:default)
def pbcopy(value); return if value.nil?; `/bin/bash -c 'echo -n "#{value}" | pbcopy'`; "#{value}    <- COPIED TO CLIPBOARD" end

def parse(input)
  input.split("\n").map { |c| c.chars.map(&:to_i) }
end

def visible?(input, row, col)
  return true if row == 0 || col == input.length - 1
  return true if col == 0 || col == input.length - 1

  height = input[row][col]
  input[row][0..(col - 1)].all? { |i| i < height } ||
    input[row][(col + 1)..].all? { |i| i < height } ||
    input[0..(row - 1)].all? { |r| r[col] < height } ||
    input[(row + 1)..].all? { |r| r[col] < height }
end

def scenic_score(input, row, col)
  return 0 if row == 0 || row == input.length - 1
  return 0 if col == 0 || col == input.length - 1

  tree = input[row][col]

  visible_trees = [
    # For each direction, find the index of the first taller tree in that
    # direction - it is one less than the number of visible trees (due to zero
    # indexing).
    #
    # If there is no taller tree, default to one less than the number
    # of trees we looked at. That way, we can add 1 either way and get this with
    # a oneliner. :rocket:
    #
    # up
    1 + (input[0..(row - 1)].map { |i| i[col] }.reverse.index { |i| i >= tree } || row - 1),
    # down
    1 + (input[(row + 1)..input.length].map { |i| i[col] }.index { |i| i >= tree } || input.length - (row + 1) - 1),
    # left
    1 + (input[row][0..(col - 1)].reverse.index { |i| i >= tree } || col - 1),
    # right
    1 + (input[row][(col + 1)..].index { |i| i >= tree } || input.length - (col + 1) - 1),
  ]

  visible_trees.inject(:*)
end

def part1(parsed)
  visible = 0

  parsed.length.times do |y|
    parsed[0].length.times do |x|
      visible += 1 if visible?(parsed, x, y)
    end
  end

  visible
end

def part2(parsed)
  best_score = 0

  parsed.length.times do |y|
    parsed[0].length.times do |x|
      current_score = scenic_score(parsed, x, y)
      best_score = current_score if current_score > best_score
    end
  end

  best_score
end

parsed = parse(ARGF.read.chomp)

puts "Part 1:"
puts pbcopy(part1(parsed))

puts
puts "Part 2:"
puts pbcopy(part2(parsed))
