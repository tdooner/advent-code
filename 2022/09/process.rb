require 'bundler'; Bundler.require(:default)
require 'set'
def pbcopy(value); return if value.nil?; `/bin/bash -c 'echo -n "#{value}" | pbcopy'`; "#{value}    <- COPIED TO CLIPBOARD" end

def parse(input)
  input.split("\n").map { |l| l.split(' ') }.map { |dir, num| [dir, num.to_i] }
end

def debug(&block)
  block.call if ENV['DEBUG']
end

def distance(x1, y1, x2, y2)
  [(x2 - x1).abs, (y2 - y1).abs].max
end


# Tom's lazy grid:
#
#            ^ negative
#            |
#       <--- 0 --> positive
# negative   |
#            v positive

def print_grid(head_row, head_col, tail_row, tail_col)
  $stdout.puts "==========="
  ([head_row, tail_row, 0].min.upto([head_row, tail_row, 0].max)).each do |row|
    ([head_col, tail_col, 0].min.upto([head_col, tail_col, 0].max)).each do |col|
      if row == head_row && col == head_col
        $stdout.write 'H'
      elsif row == tail_row && col == tail_col
        $stdout.write 'T'
      else
        $stdout.write '.'
      end
    end
    $stdout.write "\n"
  end
end

# The knot remembers its coordinates (and its name, but that's not relevant).
Knot = Struct.new(:i, :row, :col) do
  def catch_up_to(other_row, other_col)
    # WTF RUBY IS THIS WEIRD SYNTACTIC VARIABLE DECLARATION
    # WHY DO I NEED SELF HEREEEEEEEeeeee
    dist = distance(self.row, self.col, other_row, other_col)
    while dist > 1
      if other_col > self.col
        self.col += 1
        dist -= 1
      elsif other_col < self.col
        self.col -= 1
        dist -= 1
      end

      if other_row > self.row
        self.row += 1
        dist -= 1
      elsif other_row < self.row
        self.row -= 1
        dist -= 1
      end
    end
  end
end

def part1(parsed)
  visited = Set.new
  head_row = 0
  head_col = 0
  tail = Knot.new(0, 0, 0)

  parsed.each do |dir, num|
    debug { $stdout.puts "===== [ #{dir} #{num} ] =====" }

    num.times do
      case dir
      when 'L'
        head_col -= 1
      when 'R'
        head_col += 1
      when 'U'
        head_row -= 1
      when 'D'
        head_row += 1
      end

      tail.catch_up_to(head_row, head_col)

      debug { print_grid(head_row, head_col, tail.row, tail.col) }

      visited << [tail.row, tail.col]
    end
  end

  visited.length
end

def part2(parsed)
  visited = Set.new
  head = Knot.new('H', 0, 0)
  knots = 9.times.map { |i| Knot.new(i + 1, 0, 0) }

  parsed.each do |dir, num|
    debug { $stdout.puts "===== [ #{dir} #{num} ] =====" }

    num.times do
      case dir
      when 'L'
        head.col -= 1
      when 'R'
        head.col += 1
      when 'U'
        head.row -= 1
      when 'D'
        head.row += 1
      end

      ([head] + knots).each_cons(2) do |prev_knot, knot|
        knot.catch_up_to(prev_knot.row, prev_knot.col)
      end

      visited << [knots.last.row, knots.last.col]
    end
  end

  visited.length
end

parsed = parse(ARGF.read.chomp)

puts "Part 1:"
puts pbcopy(part1(parsed))

puts
puts "Part 2:"
puts pbcopy(part2(parsed))
