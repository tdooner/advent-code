require 'digest'

passcode = ARGV.shift

class State < Struct.new(:x, :y, :passcode)
  def next_moves
    hash = Digest::MD5.hexdigest(passcode)
    doors_open = hash.each_char.first(4).map { |c| %w[b c d e f].include?(c) }
    [
      (State.new(x, y - 1, passcode + 'U') if y > 0 && doors_open[0]),
      (State.new(x, y + 1, passcode + 'D') if y < 3 && doors_open[1]),
      (State.new(x - 1, y, passcode + 'L') if x > 0 && doors_open[2]),
      (State.new(x + 1, y, passcode + 'R') if x < 3 && doors_open[3]),
    ].compact
  end
end

def shortest(passcode)
  moves = [State.new(0, 0, passcode)]

  while moves.any?
    current = moves.shift

    current.next_moves.each do |move|
      return move if move.x == 3 && move.y == 3

      moves << move
    end
  end
end

def longest(passcode)
  moves = [State.new(0, 0, passcode)]
  solutions = []

  while moves.any?
    current = moves.shift

    current.next_moves.each do |move|
      if move.x == 3 && move.y == 3
        solutions << move
      else
        moves << move
      end
    end
  end

  solutions
end

if ENV['MODE'] == 'longest'
  puts longest(passcode).last.passcode.gsub(passcode, '').length
else
  puts shortest(passcode).passcode.gsub(passcode, '')
end
