require 'pry'
require 'set'

# 0. look at what we are trying to find
# 1. parse the input
input = ARGF.read.split("\n")

# 2. convert the input into a good data model (so you can loop over it)
input = input.map { |line| line.split(' | ').map { |entry| entry.split(' ') } }

# 3. solve the test input
puts 'part 1:'
puts input.sum { |_left, right| right.count { |value| [2, 3, 4, 7].include?(value.length) } }

puts 'part 2:'

# Valid options of simultaneously-lit segments, and which displayed number each
# option corresponds to.
VALID_NUMBERS = {
  'abcefg' => '0',
  'cf' => '1',
  'acdeg' => '2',
  'acdfg' => '3',
  'bcdf' => '4',
  'abdfg' => '5',
  'abdefg' => '6',
  'acf' => '7',
  'abcdefg' => '8',
  'abcdfg' => '9'
}

# Checks whether a mapping (e.g. 'deafbgc' from the part 2 example) is valid.
# A mapping is valid if every scrambled value in the `input` array can be
# converted back to a valid number via the mapping (e.g. 'dab' -> 'acf' is valid
# because it is a 7).
#
# @param {mapping} String A 7-character string with the first character being
#   the potential jumbled value of the 'a' segment, etc.
def valid_mapping?(mapping, input)
  input.all? do |value|
    VALID_NUMBERS.include?(value.tr(mapping, 'abcdefg').chars.sort.join)
  end
end

# Use the mapping to convert back to the displayed digit.
def decode(mapping, value)
  VALID_NUMBERS[value.tr(mapping, 'abcdefg').chars.sort.join]
end

answer = input.sum do |left, right|
  # Bruteforce it! For every combination of the letters A-G, find the one that
  # is a valid mapping for this input.
  valid_mapping = ('a'..'g').to_a.permutation(7).find do |mapping|
    valid_mapping?(mapping.join, left)
  end.join

  # Then, decode the four output values according to the mapping.
  output_digits = right.map { |value| decode(valid_mapping, value) }.join
  output_digits.to_i
end

puts answer
