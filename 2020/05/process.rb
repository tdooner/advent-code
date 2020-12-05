require 'pry'

def board(pass)
  row = pass[0..7]
  column = pass[7..-1]
  min = 0
  max = 127

  row.chars.each do |chr|
    half = (max - min + 1) / 2
    if chr == 'F'
      max = max - half
    elsif chr == 'B'
      min = min + half
    end
  end

  col_min = 0
  col_max = 7
  column.chars.each do |chr|
    half = (col_max - col_min + 1) / 2
    if chr == 'L'
      col_max = col_max - half
    elsif chr == 'R'
      col_min = col_min + half
    end
  end

  { col: col_max, row: max, id: max * 8 + col_max }
end

input = File.read(ARGV[0]).split(/\n/)

all = input.map { |i| board(i) }.map { |i| i[:id] }.sort
puts (all.min..all.max).to_a - all
