# frozen_string_literal: true

require 'pry'

# SKELETON SOLVING
class Solution
  def initialize(input)
    @input = input
  end

  def solve
    @input.codepoints.map { |i| i - "A".codepoints[0] + 1 }.join
  end
end

# test input:
puts Solution.new(ARGF.read.chomp).solve
