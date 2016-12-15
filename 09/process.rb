def parse(line)
  i = 0
  length = 0

  while i < line.length
    next_capture = line.index('(', i)

    if next_capture
      length += next_capture - i unless next_capture == i
    else
      length += line.length - i
      break
    end

    end_capture = line.index(')', next_capture)

    repeat_length, repeat = line[(next_capture + 1)..(end_capture - 1)].split('x').map(&:to_i)

    group = line[(end_capture + 1)..(end_capture + repeat_length)]

    if ENV['VERSION'] == '2' && group.include?('(')
      inner_length = parse(group)
    else
      inner_length = group.length
    end

    length += (inner_length * repeat)
    i = end_capture + repeat_length + 1
  end

  length
end

ARGF.each_line.each_with_index do |line, i|
  puts "#{i}: #{parse(line.strip)}"
end
