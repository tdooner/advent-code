require 'bundler'; Bundler.require(:default)
def pbcopy(value); return if value.nil?; `/bin/bash -c 'echo -n "#{value}" | pbcopy'`; "#{value}    <- COPIED TO CLIPBOARD" end

def parse(input)
  input.split("\n").map(&:chars)
end

# attempting to implement A* search
def a_star(map, start_row, start_col, asc: true)
  scores = { [start_row, start_col] => 0 }
  nodes = [[start_row, start_col]]

  while nodes.any?
    current_row, current_col = nodes.min_by { |i| scores[i] }
    current_val = map[current_row][current_col]
    if (asc && current_val == 'E') || (!asc && current_val == 'a')
      return scores[[current_row, current_col]]
    end

    nodes.delete([current_row, current_col])

    neighbors = [
      ([current_row - 1, current_col] if current_row > 0),
      ([current_row + 1, current_col] if current_row < map.length - 1),
      ([current_row, current_col - 1] if current_col > 0),
      ([current_row, current_col + 1] if current_col < map[0].length - 1),
    ].compact

    neighbors.each do |neighbor_row, neighbor_col|
      value = map[neighbor_row][neighbor_col]
      next if neighbor_row == current_row && neighbor_col == current_col

      # Logic for determining whether we can move from
      # (current_row, current_col) -> (neighbor_row, neighbor_col)
      if asc
        # part 1: we go from S -> E
        next if current_val == 'S' && value != 'a'
        next if current_val != 'S' && value.ord - current_val.ord > 1
        next if value == 'E' && current_val != 'y' && current_val != 'z'
      else
        # part 2: we go from E -> a
        next if current_val != 'E' && current_val.ord - value.ord > 1
        next if current_val == 'E' && value != 'y' && value != 'z'
        next if value == 'S' && current_val != 'a'
      end

      # Cool, we can move there. We only will *want to* if the path is shorter.
      score = scores[[current_row, current_col]] + 1
      if score < scores.fetch([neighbor_row, neighbor_col], Float::INFINITY)
        scores[[neighbor_row, neighbor_col]] = score
        unless nodes.include?([neighbor_row, neighbor_col])
          nodes << [neighbor_row, neighbor_col]
        end
      end
    end
  end
end

def part1(map)
  map = map.dup.map(&:dup) # lol

  start_row = map.find_index { |row| row.include?('S') }
  start_col = map[start_row].find_index('S')

  a_star(map, start_row, start_col, asc: true)
end

def part2(map)
  map = map.dup.map(&:dup)

  # Search backwards from E -> a rather than bruteforcing all a's to see which
  # one is shortest.
  start_row = map.find_index { |row| row.include?('E') }
  start_col = map[start_row].find_index('E')

  a_star(map, start_row, start_col, asc: false)
end

parsed = parse(ARGF.read.chomp)
#puts "PARSED: #{parsed.inspect}"

puts "Part 1:"
puts pbcopy(part1(parsed))

puts
puts "Part 2:"
puts pbcopy(part2(parsed))
