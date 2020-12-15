require 'pry'
require 'active_support'

input = $<.read.split(',').map(&:to_i)

def solve(input, stop_turn:)
  turn = 1
  spoken = {}
  last_num = nil

  input.each do |num|
    spoken[num] ||= []
    spoken[num] << turn
    turn += 1
    last_num = num
  end

  loop do
    if spoken[last_num].length > 1
      current_num = spoken[last_num][-1] - spoken[last_num][-2]
    else
      current_num = 0
    end
    return current_num if turn == stop_turn

    spoken[current_num] ||= []
    spoken[current_num] << turn
    last_num = current_num
    turn += 1
  end
end

puts 'Part 1:'
puts solve(input, stop_turn: 2020)

puts 'Part 2 (this will take ~5 min):'
puts solve(input, stop_turn: 30_000_000)
