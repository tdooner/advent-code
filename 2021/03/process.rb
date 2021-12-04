require 'pry'

input = ARGF.read.split("\n")

def most_common(list)
  counts = list.each_with_object({}) do |item, hash|
    hash[item] ||= 0
    hash[item] += 1
  end

  max_value = counts.max_by { |_, v| v }.last
  return nil if counts.select { |_, v| v == max_value }.length > 1

  counts.max_by { |_, v| v }.first
end

def gamma_value(input)
  input.first.length.times.map do |i|
    most_common(input.map { |line| line[i] })
  end.join
end

def epsilon_value(gamma_value)
  gamma_value.chars.map do |char|
    char == '0' ? '1' : '0'
  end.join
end

def oxygen_rating(input)
  numbers = input.dup
  i = 0
  while numbers.length > 1
    most_common_bit = most_common(numbers.map { |num| num[i] }) || '1'
    numbers.select! { |num| num[i] == most_common_bit }
    i += 1
  end

  numbers.first.to_i(2)
end

def co2_rating(input)
  numbers = input.dup
  i = 0
  while numbers.length > 1
    least_common_bit = most_common(numbers.map { |num| num[i] }) == '0' ? '1' : '0'
    numbers.select! { |num| num[i] == least_common_bit }
    i += 1
  end

  numbers.first.to_i(2)
end

gamma = gamma_value(input)
epsilon = epsilon_value(gamma)

puts 'Part 1:'
puts gamma.to_i(2) * epsilon.to_i(2)

puts 'Part 2:'
puts oxygen_rating(input) * co2_rating(input)
