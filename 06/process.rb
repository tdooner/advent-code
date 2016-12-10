chars = ARGF.each_line.map do |line|
  line.strip.each_char.to_a
end.transpose

answer = chars.map do |char_array|
  char_array
    .each_with_object(Hash.new(0)) { |char, hash| hash[char] += 1 }
    .sort_by { |k, v| -v }
    .first
    .first
end.join

puts answer
