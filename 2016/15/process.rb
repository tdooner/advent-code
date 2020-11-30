def process_line(line, index)
  num_positions = line.scan(/(\d+) positions/).first.first.to_i
  initial_position = line.scan(/position (\d+)/).first.first.to_i

  # puts "0 == (#{initial_position} + #{index} + tick) % #{num_positions}"
  ->(tick) { 0 == (initial_position + tick + index) % num_positions }
end

rules = []

ARGF.each_line.each_with_index do |line, index|
  rules << process_line(line.strip, index + 1)
end

i = 0
loop do
  break if rules.all? { |r| r.call(i) }
  i += 1
end

puts i
