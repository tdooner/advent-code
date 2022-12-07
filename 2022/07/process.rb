require 'bundler'; Bundler.require(:default)
def pbcopy(value); return if value.nil?; `/bin/bash -c 'echo -n "#{value}" | pbcopy'`; "#{value}    <- COPIED TO CLIPBOARD" end

def parse(input)
  input
    .split("\n")
    .map do |line|
      if line.start_with?('$ cd')
        [:cd, line[5..]]
      elsif line.start_with?('$ ls')
        [:ls]
      elsif line.start_with?('dir ')
        [:dir, line[4..]]
      else
        filesize, filename = line.split(' ')
        [:file, filesize.to_i, filename]
      end
    end
end

def part1(parsed)
  directory_sizes = {}
  cwd = []
  parsed.each do |line|
    cmd, arg1, arg2 = line

    case cmd
    when :cd
      if arg1 == '..'
        cwd.pop
      else
        cwd << arg1
      end
    when :file
      cwd.length.times do |i|
        directory_sizes[cwd[0..i]] ||= 0
        directory_sizes[cwd[0..i]] += arg1
      end
    end
  end

  directory_sizes.find_all { |k,v| v < 100_000 }.map(&:last).sum
end

def part2(parsed)
  directory_sizes = {}
  cwd = []
  parsed.each do |line|
    cmd, arg1, arg2 = line

    case cmd
    when :cd
      if arg1 == '..'
        cwd.pop
      else
        cwd << arg1
      end
    when :file
      cwd.length.times do |i|
        directory_sizes[cwd[0..i]] ||= 0
        directory_sizes[cwd[0..i]] += arg1
      end
    end
  end

  # find smallest dir to delete
  free = 70_000_000 - directory_sizes[['/']]
  needs = 30_000_000 - free

  directory_sizes.values.find_all { |s| s > needs }.min
end

parsed = parse(ARGF.read.chomp)
puts "PARSED: #{parsed.inspect}"

puts "Part 1:"
puts pbcopy(part1(parsed))

puts
puts "Part 2:"
puts pbcopy(part2(parsed))
