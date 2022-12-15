require 'bundler'; Bundler.require(:default)
def pbcopy(value); return if value.nil?; `/bin/bash -c 'echo -n "#{value}" | pbcopy'`; "#{value}    <- COPIED TO CLIPBOARD" end
def debug(&block); puts block.call if ENV['D']; end

def parse(input)
  # Sensor at x=2669347, y=190833: closest beacon is at x=2053598, y=-169389
  input
    .split("\n")
    .map { |l| l =~ /Sensor at x=([\-\d]+), y=([\-\d]+): closest beacon is at x=([\-\d]+), y=([\-\d]+)/; [$~[1], $~[2], $~[3], $~[4]].map(&:to_i) }
end

def part1(parsed)
  sensors = {}
  beacons = {}
  parsed.each do |sensor_x, sensor_y, beacon_x, beacon_y|
    beacon_distance = (beacon_x - sensor_x).abs + (beacon_y - sensor_y).abs
    sensors[[sensor_x, sensor_y]] = { distance: beacon_distance }
    beacons[[beacon_x, beacon_y]] = true
  end

  min_x, max_x = sensors.keys.map(&:first).minmax
  max_distance = sensors.values.map { |v| v[:distance] }.max
  min_x -= max_distance
  max_x += max_distance
  y = min_x < -10 ? 2_000_000 : 10 # real or test data?

  (min_x..max_x).count do |x|
    next if beacons[[x, y]] || sensors[[x, y]]

    # test if [x, y] is within a distance of a sensor
    cannot_exist = sensors.any? do |(sensor_x, sensor_y), h|
      distance = (x - sensor_x).abs + (y - sensor_y).abs

      distance <= h[:distance]
    end

    cannot_exist
  end
end

def part2(parsed)
  sensors = {}
  parsed.each do |sensor_x, sensor_y, beacon_x, beacon_y|
    beacon_distance = (beacon_x - sensor_x).abs + (beacon_y - sensor_y).abs
    sensors[[sensor_x, sensor_y]] = { distance: beacon_distance }
  end

  # autodetect test input vs actual input:
  max_xy = sensors.keys.map(&:first).any? { |i| i > 100 } ? 4_000_000 : 20

  # Cheaters note: I got the idea for this algorithm from someone else.
  #
  # Since there's only one point without a sensor, it must be right outside the
  # radius of one of the sensors' range. Let's just try each of those points by
  # stepping around the perimeter counter-clockwise from the west.
  #
  #             13
  #          14 B 12
  #         15 ### 11
  #        16 ##### 10
  #        1 ###S### 9
  #         2 ##### 8
  #          3 ### 7
  #           4 # 6
  #             5
  sensors.each do |(sensor_x, sensor_y), h|
    perimeter_x = sensor_x - h[:distance] - 1
    perimeter_y = sensor_y

    [[1, 1], [1, -1], [-1, -1], [-1, 1]].each do |dx, dy|
      (h[:distance] + 1).times do |i|
        if 0 < perimeter_x && perimeter_x < max_xy &&
            0 < perimeter_y && perimeter_y < max_xy
          blocked = sensors.any? do |(sensor_x, sensor_y), h|
            (perimeter_x - sensor_x).abs + (perimeter_y - sensor_y).abs <= h[:distance]
          end

          return perimeter_x * 4_000_000 + perimeter_y unless blocked
        end

        perimeter_x += dx
        perimeter_y += dy
      end
    end
  end
end

input = ARGF.read.chomp
#puts "PARSED: #{parse(input)}"

puts "Part 1 (this takes ~20 sec):"
puts pbcopy(part1(parse(input)))

puts
puts "Part 2:"
puts pbcopy(part2(parse(input)))
