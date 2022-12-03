require 'pry'

input = $<.read.strip.each_char.to_a.map(&:to_i)

class CircleOfCups
  def initialize(cups)
    @cups = cups
  end

  def [](i)
    while @cups[i].nil?
      i += 1
    end
    @cups[i]
  end

  def max
    @_max ||= @cups.max
  end

  def next_three(i)
    (i+1..i+3).map do |j|
      @cups[j % @cups.length]
    end
  end

  def length
    @cups.length
  end

  def index_of(value)
    @_indices ||= Hash[@cups.each_with_index.to_a]
    @_indices[value]
  end

  def insert(index, values)
    @cups.insert(index, *values)
    @_indices = nil
  end

  def delete(values)
    values.each do |val|
      @cups[index_of(val)] = nil
      @_indices[val] = nil if @_indices
    end
  end
end

def solve(cups, num_turns)
  cups = CircleOfCups.new(cups)
  i = 0
  num_turns.times do |turn|
    current_cup = cups[i]

    next_three_cups = cups.next_three(i)

    destination_cup = current_cup
    loop do
      destination_cup -= 1
      destination_cup = cups.max if destination_cup < 1
      break unless next_three_cups.include?(destination_cup)
    end

    cups.delete(next_three_cups)
    destination_index = cups.index_of(destination_cup)
    cups.insert(destination_index + 1, next_three_cups)
    i = (cups.index_of(current_cup) + 1) % cups.length
  end

  cups.length.times.map do |i|
    cups[(cups.index_of(1) + i) % cups.length]
  end.join[1..]
end

def extend_input_to_one_million(input)
  num_cups = input.length
  input.concat((num_cups+1..1_000_000).to_a)
end

puts 'Part 1:'
puts solve(input, 100) # 52864379

puts 'Part 2:'
#puts solve(extend_input_to_one_million(input), 10_000_000)
