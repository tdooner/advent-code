require 'bundler'; Bundler.require(:default)
def pbcopy(value); return if value.nil?; `/bin/bash -c 'echo -n "#{value}" | pbcopy'`; "#{value}    <- COPIED TO CLIPBOARD" end
def debug(&block); puts block.call if ENV['D'].present?; end

def parse(input)
  occupied = {}
  bottom_row = 0

  input.split("\n").map { |l| l.split(' -> ') }.each do |path|
    path.each_cons(2) do |start, end_path|
      start_col, start_row = start.split(',').map(&:to_i)
      end_col, end_row = end_path.split(',').map(&:to_i)

      if start_col == end_col
        if end_row > start_row
          bottom_row = end_row if end_row > bottom_row
          (start_row..end_row).each do |row|
            occupied[[start_col, row]] = :wall
          end
        else
          bottom_row = start_row if start_row > bottom_row
          (end_row..start_row).each do |row|
            occupied[[start_col, row]] = :wall
          end
        end
      elsif start_row == end_row
        if end_col > start_col
          (start_col..end_col).each do |col|
            occupied[[col, start_row]] = :wall
          end
        else
          (end_col..start_col).each do |col|
            occupied[[col, start_row]] = :wall
          end
        end
      end
    end
  end

  [occupied, bottom_row]
end

def print(map, floor: nil)
  min_col, max_col = map.keys.map(&:first).minmax
  min_row, max_row = [0, map.keys.map(&:last).max]
  max_row = floor if floor

  (min_row..max_row).map do |row|
    (min_col..max_col).map do |col|
      case map[[col, row]]
      when :wall
        '#'
      when :sand
        'O'
      else
        if floor && row == floor
          '#'
        else
          '.'
        end
      end
    end.join
  end.join("\n")
end

def drop_sand(map, start_col = 500, start_row = 0, bottom_row = 0)
  sand_coordinates = [start_col, start_row]
  sand_settled = false

  while (!sand_settled)
    next_coordinates = [sand_coordinates[0], sand_coordinates[1] + 1]

    if map[next_coordinates].nil?
      # fall directly down
      if next_coordinates[1] == bottom_row
        return :fell_off
      end
      sand_coordinates = next_coordinates
    else
      # if blocked, try to fall to the bottom left
      if map[[next_coordinates[0] - 1, next_coordinates[1]]].nil?
        if next_coordinates[1] == bottom_row
          return :fell_off
        end

        result = drop_sand(map, next_coordinates[0] - 1, next_coordinates[1], bottom_row)
        return result if result == :fell_off
        sand_settled = true
      # otherwise, fall to the bottom right
      elsif map[[next_coordinates[0] + 1, next_coordinates[1]]].nil?
        if next_coordinates[1] == bottom_row
          return :fell_off
        end
        result = drop_sand(map, next_coordinates[0] + 1, next_coordinates[1], bottom_row)
        return result if result == :fell_off
        sand_settled = true
      else
        map[sand_coordinates] = :sand
        sand_settled = true
      end
    end
  end
end

# Part 2 where there is actually a floor at the bottom_row.
def drop_sand_2(map, start_col = 500, start_row = 0, bottom_row = 0)
  sand_coordinates = [start_col, start_row]
  return :blocked_input if map[sand_coordinates] == :sand

  sand_settled = false

  while (!sand_settled)
    next_coordinates = [sand_coordinates[0], sand_coordinates[1] + 1]

    if map[next_coordinates].nil? && next_coordinates[1] != bottom_row
      sand_coordinates = next_coordinates
    else
      # if blocked, try to fall to the bottom left
      if map[[next_coordinates[0] - 1, next_coordinates[1]]].nil? && next_coordinates[1] != bottom_row
        drop_sand_2(map, next_coordinates[0] - 1, next_coordinates[1], bottom_row)
        sand_settled = true
      # otherwise, fall to the bottom right
      elsif map[[next_coordinates[0] + 1, next_coordinates[1]]].nil? && next_coordinates[1] != bottom_row
        drop_sand_2(map, next_coordinates[0] + 1, next_coordinates[1], bottom_row)
        sand_settled = true
      else
        map[sand_coordinates] = :sand
        sand_settled = true
      end
    end
  end
end

def part1(parsed)
  map, bottom_row = parsed
  sand_counter = 0
  loop do
    result = drop_sand(map, 500, 0, bottom_row)
    break if result == :fell_off
    sand_counter += 1
    debug { puts print(map) }
  end

  sand_counter
end

def part2(parsed)
  map, bottom_row = parsed

  sand_counter = 0
  loop do
    result = drop_sand_2(map, 500, 0, bottom_row + 2)
    break if result == :blocked_input
    sand_counter += 1
    debug { puts print(map, floor: bottom_row + 2) }
  end

  sand_counter
end

input = ARGF.read.chomp
#puts "PARSED: #{parse(input)}"

puts "Part 1:"
puts pbcopy(part1(parse(input)))

puts
puts "Part 2 (this takes ~10 sec):"
puts pbcopy(part2(parse(input)))
