require 'pry'
input = $<.map { |l| l.strip }
#input = $<.read.split("\n\n")

class HexFloor
  DIRECTIONS = /e|se|sw|w|nw|ne/

  def initialize
    # @floor is a hash where
    # key = (x, y) coordinates of hex center
    # value = is_black
    @floor = {}
  end

  def flip_coords(directions)
    x, y = [0, 0]

    directions.scan(*DIRECTIONS).each do |step|
      x += 1 if step.include?('e')
      x += 1 if step == 'e'
      x -= 1 if step.include?('w')
      x -= 1 if step == 'w'
      y -= 1 if step.include?('n')
      y += 1 if step.include?('s')
    end

    @floor[[x, y]] = !@floor.fetch([x, y], false)
  end

  def black_tiles
    @floor.find_all { |k, v| v == true }.map(&:first)
  end

  def flip_tiles_for_tomorrow
    # expand tiles in collection, to add a ring of white tiles around each black
    # tile (since those are the only ones that can flip)
    black_tiles.each do |(x, y)|
      each_adjacent_index(x, y) do |(new_x, new_y)|
        next if @floor.include?([new_x, new_y])
        @floor[[new_x, new_y]] = false
      end
    end

    new_floor = {}

    # flip white -> black
    @floor.each do |(x, y), is_black|
      next if is_black
      adjacent_black_tiles = each_adjacent_index(x, y).count do |x2, y2|
        @floor[[x2, y2]] == true
      end
      if adjacent_black_tiles == 2
        new_floor[[x, y]] = true
      else
        new_floor[[x, y]] = false
      end
    end

    # flip black -> white
    @floor.each do |(x, y), is_black|
      next unless is_black
      adjacent_black_tiles = each_adjacent_index(x, y).count do |x2, y2|
        @floor[[x2, y2]] == true
      end
      if adjacent_black_tiles == 0 || adjacent_black_tiles > 2
        new_floor[[x, y]] = false
      else
        new_floor[[x, y]] = true
      end
    end

    @floor = new_floor
  end

  def each_adjacent_index(x, y)
    return to_enum(:each_adjacent_index, x, y) unless block_given?
    yield [x - 2, y]          # west
    yield [x + 2, y]          # east
    yield [x + 1, y - 1] # northeast
    yield [x + 1, y + 1] # southeast
    yield [x - 1, y - 1] # northwest
    yield [x - 1, y + 1] # southwest
  end
end

def solve(input)
  f = HexFloor.new
  input.each do |directions|
    f.flip_coords(directions)
  end

  f.black_tiles.count
end

def solve2(input)
  f = HexFloor.new
  input.each do |directions|
    f.flip_coords(directions)
  end

  100.times do |i|
    f.flip_tiles_for_tomorrow
    puts "Day #{i + 1}: #{f.black_tiles.count}" if i + 1 <= 10 || (i + 1) % 10 == 0
  end

  f.black_tiles.count
end

puts 'Part 1:'
puts solve(input)

puts 'Part 2:'
puts solve2(input)
