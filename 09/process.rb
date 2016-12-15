def parse(line)
  i = 0
  output = ''

  while i < line.length
    next_capture = line.index('(', i)

    if next_capture
      output << line[i..(next_capture - 1)] unless next_capture == i
    else
      output << line[i..-1]
      break
    end

    end_capture = line.index(')', next_capture)

    length, repeat = line[(next_capture + 1)..(end_capture - 1)].split('x').map(&:to_i)
    group = line[(end_capture + 1)..(end_capture + length)]
    if ENV['VERSION'] == '2' && group.include?('(')
      group = parse(group)
    end
    output << (group * repeat)
    i = end_capture + length + 1
  end

  output
end

ARGF.each_line.each_with_index do |line, i|
  puts "#{i}: #{parse(line.strip).length}"
end
