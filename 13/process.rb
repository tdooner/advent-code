require 'set'
class Board
  def initialize(favorite_number)
    @favorite_number = favorite_number
  end

  def search(startx, starty, destx, desty)
    distances = {
      [startx, starty] => 0,
    }
    previous = {}

    nodes = [[startx, starty]]
    while nodes.any?
      current = nodes.shift

      neighbors(*current).each do |node|
        if node == [destx, desty]
          path = [current, node]
          while previous[path[0]] != [startx, starty]
            path.unshift(previous[path[0]])
          end
          return path
        end

        next if distances[node]
        distances[node] = distances[current] + 1
        previous[node] = current
        nodes << node
      end
    end
  end

  def to_s(path, destination)
    maxx = [destination[0]].concat(path.map(&:first)).sort.last + 1 + 10
    maxy = [destination[1]].concat(path.map(&:last)).sort.last + 1 + 10

    str = '   ' + (maxx.times.map { |y| '%2s' % y }.join(' '))

    maxy.times do |y|
      squares = maxx.times.map do |x|
        path.include?([x, y]) ? "\e[0;32m  O\e[1;0m" : valid?(x, y) ? ' ' : '#'
      end
      str << ("\n%2s" + ('%3s' * maxx)) % [y].concat(squares)
    end

    str
  end

  private

  def neighbors(x, y)
    [
      [x    , y + 1],
      [x    , y - 1],
      [x + 1, y    ],
      [x - 1, y    ],
    ].keep_if { |x2, y2| valid?(x2, y2) }
  end

  def distance(x1, y1, x2, y2)
    (x2 - x1).abs + (y2 - y1).abs
  end

  def valid?(x, y)
    return false if x < 0 || y < 0

    # I think (1, 1) is a special case and always valid
    return true if x == 1 && y == 1

    num = x * x + 3 * x + 2 * x * y + y + y * y + @favorite_number
    num.to_s(2).each_char.count { |c| c == '1' } % 2 == 0
  end
end

favorite_number = ARGV.shift.to_i
destination = ARGV.shift.split(',').map(&:to_i)

b = Board.new(favorite_number)
path = b.search(1, 1, destination[0], destination[1])
puts path.length
puts b.to_s(path, destination)
