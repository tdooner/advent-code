def password_valid_part_1?(str)
  rule, password = str.split(': ')
  minmax, letter = rule.split(' ')
  min, max = minmax.split('-').map(&:to_i)

  password.count(letter) >= min &&
    password.count(letter) <= max
end

def password_valid_part_2?(str)
  rule, password = str.split(': ')
  minmax, letter = rule.split(' ')
  min, max = minmax.split('-').map(&:to_i)

  (password[min - 1] == letter) ^ (password[max - 1] == letter)
end


input = File.read('input').each_line.map(&:strip)

puts 'Part 1:'
puts(input.count { |i| password_valid_part_1?(i) })

puts 'Part 2:'
puts(input.count { |i| password_valid_part_2?(i) })
