input = $<.map(&:strip)
require 'pry'

def process(input)
  start = input.shift.to_i
  buses = input[0].split(',').find_all { |i| i != 'x' }.map(&:to_i)

  earliest = start
  bus_id = nil
  loop do
    earliest += 1
    bus_id = buses.find do |bus|
      earliest % bus == 0
    end
    break if bus_id
  end

  (earliest - start) * bus_id
end

def earliest_for_all(input)
  # give up for now
end

puts 'Part 1:'
puts process(input.dup)

puts 'Part 2:'
puts earliest_for_all(input)
