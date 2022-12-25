require 'bundler'; Bundler.require(:default)
def pbcopy(value); return if value.nil?; `/bin/bash -c 'echo -n "#{value}" | pbcopy'`; "#{value}    <- COPIED TO CLIPBOARD" end
def debug(&block); puts block.call if ENV['D'].present?; end

def new_block_coords(n, r, c)
  case n % 5
  when 0
    [[r, c], [r, c + 1], [r, c + 2], [r, c + 3]]
  when 1
    [[r - 2, c + 1], [r - 1, c], [r - 1, c + 1], [r - 1, c + 2], [r, c + 1]]
  when 2
    [[r, c], [r, c + 1], [r, c + 2], [r - 1, c + 2], [r - 2, c + 2]]
  when 3
    [[r, c], [r - 1, c], [r - 2, c], [r - 3, c]]
  when 4
    [[r, c], [r - 1, c], [r, c + 1], [r - 1, c + 1]]
  end
end

def parse(input)
  input.chars
end

def print_board(board, current_piece = [])
  min_row = (board.keys + current_piece).sort.first&.first || 0

  ((min_row - 3)..0).map do |row|
    "|" + (0..6).map do |col|
      if current_piece.include?([row, col])
        '@'
      else
        board[[row, col]] || '.'
      end
    end.join + "|"
  end.join("\n") + "\n+-------+"
end

def play_game(moves, pieces)
  board = {}
  move_i = 0

  pieces.times do |n|
    min_row = board.keys.sort.first&.first || 1
    coords = new_block_coords(n, min_row - 4, 2)
    debug { print_board(board, coords) }
    settled = false

    until settled
      # try to move left/right first
      case moves[move_i % moves.length]
      when '<'
        new_coords = coords.map { |r, c| [r, c - 1] }
        coords = new_coords if new_coords.none? { |r, c| c < 0 || c > 6 || board[[r, c]] }
      when '>'
        new_coords = coords.map { |r, c| [r, c + 1] }
        coords = new_coords if new_coords.none? { |r, c| c < 0 || c > 6 || board[[r, c]] }
      end

      # then move down
      new_coords = coords.map { |r, c| [r + 1, c] }
      if new_coords.any? { |r, c| r > 0 || board[[r, c]] }
        settled = true
        coords.each { |r, c| board[[r, c]] = '#' }
      else
        coords = new_coords
      end

      move_i += 1
    end
  end

  board
end

def part1(moves)
  board = play_game(moves, 2022)

  1 + board.keys.sort.first.first * -1
end

def part2(moves)
  # TODO
end

input = ARGF.read.chomp
#puts "PARSED: #{parse(input)}"

puts "Part 1:"
puts pbcopy(part1(parse(input)))

puts
puts "Part 2:"
#puts pbcopy(part2(parse(input)))
