require 'pry'

input = $<.map(&:strip)

def solve(input)
  bitmask = nil
  mem = {}

  input.map do |line|
    cmd, value = line.split(' = ')
    if cmd == 'mask'
      bitmask = value.reverse
    else
      mem_id = cmd[4..-2]
      binary = value.to_i.to_s(2).each_char.map(&:to_i).reverse
      masked_value = bitmask.each_char.each_with_index.map do |mask, i|
        bit = binary[i] || 0
        if mask == 'X'
          bit
        else
          mask
        end
      end.reverse.join.to_i(2)
      puts [mem_id, masked_value].inspect

      mem[mem_id] = masked_value
    end
  end

  mem.values.sum
end

def each_x(str)
  num_x = str.count('X')
  (0...2**num_x).each do |i|
    binary = i.to_s(2).reverse.each_char.to_a
    new_str = str.dup

    loop do
      break unless new_str['X']
      new_str['X'] = binary.shift || '0'
    end

    yield new_str.to_i(2)
  end
end

def solve2(input)
  bitmask = nil
  mem = {}

  input.map do |line|
    cmd, value = line.split(' = ')
    if cmd == 'mask'
      bitmask = value.reverse
    else
      mem_id = cmd[4..-2]
      binary = mem_id.to_i.to_s(2).each_char.map(&:to_i).reverse
      masked_value = bitmask.each_char.each_with_index.map do |mask, i|
        bit = binary[i] || 0
        if mask == '0'
          bit
        else
          mask
        end
      end.reverse.join

      each_x(masked_value) do |address|
        mem[address] = value.to_i
      end
    end
  end

  mem.values.sum
end

puts 'Part 1:'
puts solve(input).inspect

puts 'Part 2:'
puts solve2(input).inspect
