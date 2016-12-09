valid_count = 0

ARGF.each_line.map(&:strip).map(&:split).each do |first, second, third|
  min, med, max = [first.to_i, second.to_i, third.to_i].sort

  valid_count += 1 if (min + med > max)
end

puts valid_count
