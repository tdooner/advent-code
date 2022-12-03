input = $<.map(&:to_i)

def solve(input)
  diffs = input.sort.each_cons(2).map { |a1, a2| a2 - a1 }

  (diffs.count { |d| d == 3 } + 1) *
  (diffs.count { |d| d == 1 } + 1)
end

def count_arrangements(input, start)
  eligible = input[(start+1)..]
    .each_with_index
    .find_all { |a, _i| a <= input[start] + 3 }

  eligible.sum { |_a, i| count_arrangements(input, start + i + 1) }
end

def count_arrangements_2(input)
  matrix = []
  input.each_with_index.reverse_each do |el, i|
    eligible = if i + 1 == input.length
                 1
               else
                 input[i+1..i+4].count { |el2| el2 <= el + 3 }
               end

    matrix[i] = eligible
  end

  puts matrix.inspect

  matrix.each_with_index.reverse_each do |el, i|
    puts [i, el, matrix].inspect
    next if i == input.length - 1
    valid_indices = ((i+1)..(i+4)).find_all { |i2| input[i2] && input[i2] <= input[i] + 3 }
    puts [valid_indices, matrix.values_at(*valid_indices)].inspect
    matrix[i] = matrix.values_at(*valid_indices).inject(1, :*)
  end
end

# puts solve(input).inspect

input.sort!
# puts count_arrangements(input, 0).inspect
puts count_arrangements_2(input).inspect
