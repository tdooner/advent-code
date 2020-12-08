require 'pry'
require 'set'

def run_until_loop(input)
  acc = 0
  idx = 0
  visited = Set.new
  loop do
    visited << idx
    case input[idx][0]
    when 'nop'
      idx += 1
    when 'acc'
      acc += input[idx][1]
      idx += 1
    when 'jmp'
      idx += input[idx][1]
    end
    break if visited.include?(idx)
    break if idx >= input.length
  end

  acc
end

def run_backwards(input)
  terminating_indices = Set.new()
  terminating_indices << input.length - 1 

  loop do
    new_terminating_indices = Set.new

    input.each_with_index do |(opp, int), i|
      case opp
      when 'nop', 'acc'
        if terminating_indices.include?(i + 1)
          new_terminating_indices << i
        end
      when 'jmp'
        if terminating_indices.include?(i + int)
          new_terminating_indices << i
        end
      end
    end

    break if (new_terminating_indices - terminating_indices).none?
    terminating_indices |= new_terminating_indices
  end

  infinite_looping_indices = Set.new
  idx = 0
  loop do
    infinite_looping_indices << idx
    case input[idx][0]
    when 'nop'
      idx += 1
    when 'acc'
      idx += 1
    when 'jmp'
      idx += input[idx][1]
    end
    break if infinite_looping_indices.include?(idx)
  end

  infinite_looping_indices.each do |i|
    opp, int = input[i]
    case opp
    when 'nop'
      if terminating_indices.include?(i + int)
        puts "  Changing idx=#{i} from nop to jmp"
        new_input = input.dup.tap { |n| n[i][0] = 'jmp' }
        puts "  #{run_until_loop(new_input)}"
      end
    when 'jmp'
      if terminating_indices.include?(i + 1)
        puts "  Changing idx=#{i} from jmp to nop"
        new_input = input.dup.tap { |n| n[i][0] = 'nop' }
        puts "  #{run_until_loop(new_input)}"
      end
    end
  end

  run_until_loop(input)
end

input = File.read(ARGV[0]).split(/\n/).map(&:strip)
  .map { |l| l.split(' ') }
  .map { |opp, int| [opp, int.to_i] }

puts 'Part 1:'
puts run_until_loop(input)

puts 'Part 2:'
puts run_backwards(input)
