require 'bundler'; Bundler.require(:default)
def pbcopy(value); return if value.nil?; `/bin/bash -c 'echo -n "#{value}" | pbcopy'`; "#{value}    <- COPIED TO CLIPBOARD" end
def debug(&block); puts block.call if ENV['D'].present?; end

def parse(input)
  board, path = input.split("\n\n")

  {
    board: board.each_line.each_with_index.each_with_object({}) do |(line, row), hash|
      line.chars.each_with_index do |char, col|
        hash[[row, col]] = char if char.present?
      end
    end,
    path: path.scan(/\d+|R|L/)
  }
end
FACINGS = %i[right down left up]

def part1(hash)
  coords = hash[:board].keys.sort.first
  facing = FACINGS.first

  hash[:path].each do |movement|
    case movement
    when 'R'
      facing = FACINGS[(FACINGS.index(facing) + 1) % FACINGS.length]
    when 'L'
      facing = FACINGS[(FACINGS.index(facing) - 1) % FACINGS.length]
    else
      movement.to_i.times do
        row, col = coords
        case facing
        when :right
          next_coords = [row, col + 1]
          unless hash[:board].include?(next_coords)
            # loop back to left side of board
            min_col = hash[:board].keys.filter_map { |r, c| c if r == row }.min
            next_coords = [row, min_col]
          end
        when :down
          next_coords = [row + 1, col]
          unless hash[:board].include?(next_coords)
            # loop back to top of board
            min_row = hash[:board].keys.filter_map { |r, c| r if c == col }.min
            next_coords = [min_row, col]
          end
        when :left
          next_coords = [row, col - 1]
          unless hash[:board].include?(next_coords)
            # loop back to right side of board
            max_col = hash[:board].keys.filter_map { |r, c| c if r == row }.max
            next_coords = [row, max_col]
          end
        when :up
          next_coords = [row - 1, col]
          unless hash[:board].include?(next_coords)
            # loop back to bottom of board
            max_row = hash[:board].keys.filter_map { |r, c| r if c == col }.max
            next_coords = [max_row, col]
          end
        end

        coords = next_coords unless hash[:board][next_coords] == '#'
      end
    end
  end

  row, col = coords
  (row + 1) * 1000 + (col + 1) * 4 + FACINGS.index(facing)
end

#
#        1   2
#
#        3
#
#   4    5
#
#   6
#
#                   6
#               ______
#             /  1   /|
#            /______/ |
#          4 |  3  | 2/
#            |_____| /
#               5
#

def part2(hash)
  # TEST INPUT DATA
  #     1
  # 2 3 4
  #     5 6
  #                   2
  #               ______
  #             /  1   /|
  #            /______/ |
  #          3 |  4  | 6/
  #            |_____| /
  #               5
end

input = ARGF.read.chomp
puts "PARSED: #{parse(input)}"

puts "Part 1:"
puts pbcopy(part1(parse(input)))

puts
puts "Part 2:"
puts pbcopy(part2(parse(input)))
