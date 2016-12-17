initial_state = ARGV.shift
disk_size = ARGV.shift.to_i

# returns a string of at least {size} starting from {initial}
def stretch_data(data, size)
  while data.length < size
    b = data.dup.reverse.each_char.map { |c| c == '1' ? '0' : '1' }.join
    data = "#{data}0#{b}"
  end

  data
end

def checksum(data)
  checksum = data.dup

  loop do
    checksum = checksum.each_char.each_slice(2).map { |a, b| a == b ? '1' : '0' }.join

    return checksum if checksum.length % 2 == 1
  end
end

puts checksum(stretch_data(initial_state, disk_size)[0..(disk_size - 1)])
