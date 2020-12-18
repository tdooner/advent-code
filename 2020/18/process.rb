require 'pry'
input = $<.map { |l| l.strip.each_char.to_a }

def sum_range(input)
  stack = []
  current_index = 0

  loop do
    char = input[current_index]
    case char
    when nil, ')'
      return [stack.first, current_index]
    when /\d+/
      if stack.last.is_a?(Symbol)
        operand, operator = stack.pop(2)
        stack << operand.send(operator, char.to_i)
      else
        stack << $~[0].to_i
      end
    when /[+*]/
      stack << $~[0].to_sym
    when '('
      inner, consumed = sum_range(input[current_index+1..])
      if stack.last.is_a?(Symbol)
        operand, operator = stack.pop(2)
        stack << operand.send(operator, inner)
      else
        stack << inner
      end
      current_index += consumed + 1
    end
    current_index += 1
  end
end

def sum_range2(input)
  stack = []
  current_index = 0

  loop do
    char = input[current_index]
    case char
    when nil, ')'
      while stack.length > 1
        o1, operand, o2 = stack.shift(3)
        stack.unshift(o1.send(operand, o2))
      end
      return [stack.first, current_index]
    when /\d+/
      if stack.last == :+
        operand, operator = stack.pop(2)
        stack << operand.send(operator, char.to_i)
      else
        stack << $~[0].to_i
      end
    when /[+*]/
      stack << $~[0].to_sym
    when '('
      inner, consumed = sum_range2(input[current_index+1..])
      if stack.last == :+
        operand, operator = stack.pop(2)
        stack << operand.send(operator, inner)
      else
        stack << inner
      end
      current_index += consumed + 1
    end
    current_index += 1
  end
end

def solve(input)
  input.sum do |line|
    sum, _ = sum_range(line)
    sum
  end
end

def solve2(input)
  input.sum do |line|
    sum, _ = sum_range2(line)
    sum
  end
end

puts 'Part 1:'
puts solve(input)

puts 'Part 2:'
puts solve2(input)
