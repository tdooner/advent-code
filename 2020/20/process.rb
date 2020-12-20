require 'pry'
#input = $<.map { |l| l.strip }
input = $<.read.split("\n\n")

SEA_MONSTER = <<~MONSTER
                  #
#    ##    ##    ###
 #  #  #  #  #  #
MONSTER

def rotate(lines)
  width = lines.length

  # new first row is the old first column, reversed
  width.times.map do |new_row|
    width.times.map { |new_col| lines[new_col][width - new_row - 1] }.join
  end
end

def flip_x(lines)
  lines.map do |line|
    line.each_char.to_a.reverse.join
  end
end

def flip_y(lines)
  lines.reverse
end

def remove_borders(tile)
  tile[1..-2].map { |row| row[1..-2] }
end

# side is side of the existing
def matches?(existing, next_tile, side)
  existing_side, next_side =
    case side
    when :left
      [
        existing.map { |row| row[0] },
        next_tile.map { |row| row[-1] }
      ]
    when :top
      [
        existing.first,
        next_tile.last
      ]
    when :bottom
      [
        existing.last,
        next_tile.first
      ]
    when :right
      [
        existing.map { |row| row[-1] },
        next_tile.map { |row| row[0] }
      ]
    end

  existing_side == next_side
end

def all_transformations(tile)
  Enumerator.new do |y|
    y << tile
    y << flip_x(tile)
    y << flip_y(tile)
    #y << flip_x(flip_y(tile)) #redundant?
    y << (rotated = rotate(tile)) # 90 deg
    y << flip_x(rotated)
    y << flip_y(rotated)
    y << flip_x(flip_y(rotated)) # equiv to rotated 270 deg
    y << (rotated = rotate(rotated)) # 180 deg
    #redundant?
    #y << flip_x(rotated)
    #y << flip_y(rotated)
    #y << flip_x(flip_y(rotated))
    #y << (rotated = rotate(rotated)) # 270 deg
    #y << flip_x(rotated)
    #y << flip_y(rotated)
    #y << flip_x(flip_y(rotated))
  end
end

def next_matching_tiles(state, tiles, used)
  width = Math.sqrt(tiles.length).to_i
  last_tile_x = state.length % width
  last_tile_y = state.length / width

  (tiles.keys - used).map do |id|
    all_transformations(tiles[id]).find_all do |transformed|
      (last_tile_x == 0 || matches?(state[-1], transformed, :right)) &&
      (last_tile_y == 0 || matches?(state[-1 * width], transformed, :bottom))
    end.map { |tile| [id, tile] }.uniq
  end.flatten(1)
end

def multiply_corners(used)
  width = Math.sqrt(used.length)
  top_left     = used[0]
  top_right    = used[width - 1]
  bottom_left  = used[-1 * width]
  bottom_right = used[-1]

  top_left * top_right * bottom_left * bottom_right
end

def hunt_sea_monsters(state)
  width = Math.sqrt(state.length)
  borderless = state.map { |tile| remove_borders(tile) }
  mega_tile = borderless.each_slice(width).map { |slice| slice.transpose.map(&:join) }.flatten
  sea_monster_coords = SEA_MONSTER.each_line.each_with_index.flat_map do |line, y|
    line.each_char.each_with_index.map do |char, x|
      next unless char == '#'
      [x, y]
    end.compact
  end

  sea_monsters = []
  width = mega_tile.length
  transformed_mega_tile = all_transformations(mega_tile).find do |transformed|
    width.times do |x|
      width.times do |y|
        sea_monsters << [x, y] if sea_monster_coords.all? do |dx, dy|
          0 < (x + dx) && (x + dx) < width &&
            0 < (y + dy) && (y + dy) < width &&
            transformed[y + dy][x + dx] == '#'
        end
      end
    end

    sea_monsters.any?
  end
  raise 'no sea monsters :(' unless transformed_mega_tile

  sea_monsters.each do |(start_x, start_y)|
    sea_monster_coords.each do |(dx, dy)|
      transformed_mega_tile[start_y + dy][start_x + dx] = 'O'
    end
  end

  transformed_mega_tile.sum { |line| line.count('#') }
end

def bruteforce_solution(input)
  tiles = Hash[input.map do |chunk|
    lines = chunk.split("\n")
    id = lines[0].scan(/\d+/).first.to_i
    data = lines[1..]
    [id, data]
  end]

  tiles.each_with_index do |(id, initial_tile), i|
    puts "trying #{i} of #{tiles.length}"
    all_transformations(initial_tile).each do |tile|
      state = [tile]
      used = [id]

      loop do
        matches = next_matching_tiles(state, tiles, used)
        break unless matches.any?
        raise 'too many matches' unless matches.length == 1
        state << matches[0][1]
        used << matches[0][0]
        return [tiles, used, state] if state.length == tiles.length
      end
    end
  end
end

tiles, used, state = bruteforce_solution(input)

puts 'Part 1:'
puts multiply_corners(used)

puts 'Part 2:'
puts hunt_sea_monsters(state)
