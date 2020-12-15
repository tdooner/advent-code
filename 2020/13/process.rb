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

# stolen from rosetta code
def extended_gcd(a, b)
  last_remainder, remainder = a.abs, b.abs
  x, last_x, y, last_y = 0, 1, 1, 0
  while remainder != 0
    last_remainder, (quotient, remainder) = remainder, last_remainder.divmod(remainder)
    x, last_x = last_x - quotient*x, x
    y, last_y = last_y - quotient*y, y
  end

  return last_remainder, last_x * (a < 0 ? -1 : 1)
end

def invmod(e, et)
  g, x = extended_gcd(e, et)
  if g != 1
    raise 'The maths are broken!'
  end
  x % et
end

# Implemented based on this page:
# https://brilliant.org/wiki/chinese-remainder-theorem/
def chinese_remainder_theorem(a, n)
  big_n = n.reduce(1, :*)
  y = n.map { |n_i| big_n / n_i }
  z = y.zip(n).map { |y_i, n_i| invmod(y_i, n_i) }

  a.zip(y, z).sum { |a_i, y_i, z_i| a_i * y_i * z_i } % big_n
end

def earliest_for_all(input)
  start = input.shift.to_i
  buses = input[0].split(',').each_with_index.find_all { |bus, i| bus != 'x' }.map { |bus, i| [bus.to_i, i] }

  puts 'Chinese Remainder Theorem:'
  buses = buses.map do |bus, time_offset|
    puts "x = #{(bus - time_offset) % bus} mod #{bus}"

    [(bus - time_offset) % bus, bus]
  end

  puts chinese_remainder_theorem(buses.map(&:first), buses.map(&:last))
end

puts 'Part 1:'
puts process(input.dup)

puts 'Part 2:'
puts earliest_for_all(input)
