# frozen_string_literal: true

require 'pry'

class Solution
  def initialize(input)
    @numbers = input.each_line.map(&:strip).map(&:to_i)
  end

  def solve
    first, second = @numbers.permutation(2).detect do |a, b|
      a + b == 2020
    end

    first * second
  end

  def solve_part_2
    first, second, third = @numbers.permutation(3).detect do |a, b, c|
      a + b + c == 2020
    end

    first * second * third
  end
end

puts Solution.new(ARGF.read.chomp).solve_part_2
