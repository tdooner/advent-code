require 'bundler'; Bundler.require(:default)
def pbcopy(value); return if value.nil?; `/bin/bash -c 'echo -n "#{value}" | pbcopy'`; "#{value}    <- COPIED TO CLIPBOARD" end
def debug(&block); puts block.call if ENV['D'].present?; end

def parse(input)
  input
    .split("\n")
    .map { |l| l.split(',').map(&:to_i) }
end

def part1(cubes)
  cubes.sum do |x, y, z|
    adjoining = [
      [x - 1, y, z],
      [x + 1, y, z],
      [x, y - 1, z],
      [x, y + 1, z],
      [x, y, z - 1],
      [x, y, z + 1]
    ]

    6 - adjoining.count { |coords| cubes.include?(coords) }
  end
end

def part2(cubes)
  min_x, max_x = cubes.map { |c| c[0] }.minmax
  min_y, max_y = cubes.map { |c| c[1] }.minmax
  min_z, max_z = cubes.map { |c| c[2] }.minmax

  # borrowed this idea from @topaz.
  #
  # create a hash of "exterior" coordinates (initially false, but expand
  # it breath-first).
  #
  # then, any cube not reachable from the exterior search is an interior mass.
  #
  # we can use the same surface area calculation to subtract out the internal
  # area.
  exterior =
    Array(min_x - 1..max_x + 1)
    .product(Array(min_y - 1..max_y + 1))
    .product(Array(min_z - 1..max_z + 1))
    .each_with_object({}) do |((x, y), z), hash|
      next if cubes.include?([x, y, z])

      hash[[x, y, z]] = false
    end

  q = [[min_x - 1, min_y - 1, min_z - 1]]
  while (cube = q.shift)
    x, y, z = cube
    exterior[cube] = true

    [
      [x - 1, y, z],
      [x + 1, y, z],
      [x, y - 1, z],
      [x, y + 1, z],
      [x, y, z - 1],
      [x, y, z + 1]
    ].each do |nx, ny, nz|
      next unless exterior.include?([nx, ny, nz])
      next unless exterior[[nx, ny, nz]] == false
      next if q.include?([nx, ny, nz])

      q << [nx, ny, nz]
    end
  end

  interior_cubes = exterior.filter_map { |k, v| k if v == false }

  part1(cubes) - part1(interior_cubes)
end

input = ARGF.read.chomp
#puts "PARSED: #{parse(input)}"

puts "Part 1:"
puts pbcopy(part1(parse(input)))

puts
puts "Part 2:"
puts pbcopy(part2(parse(input)))
