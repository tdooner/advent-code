require 'pry'

def binary_search(input, min, max, min_half_char, max_half_char)
  input.chars.each do |chr|
    half = (max - min + 1) / 2
    if chr == min_half_char
      max = max - half
    elsif chr == max_half_char
      min = min + half
    end
  end

  max
end

def identify_seat(input)
  row = binary_search(input[0..7], 0, 127, 'F', 'B')
  column = binary_search(input[7..9], 0, 7, 'L', 'R')

  {
    row: row,
    col: column,
    id: row * 8 + column,
  }
end

input = File.read(ARGV[0]).split(/\n/)

puts 'Part 1:'
puts input.map { |i| identify_seat(i) }.max_by { |i| i[:id] }

puts 'Part 2:'
given_ids = input.map { |i| identify_seat(i) }.map { |i| i[:id] }
puts (given_ids.min..given_ids.max).to_a - given_ids
