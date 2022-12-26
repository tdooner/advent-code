require 'bundler'; Bundler.require(:default)
def pbcopy(value); return if value.nil?; `/bin/bash -c 'echo -n "#{value}" | pbcopy'`; "#{value}    <- COPIED TO CLIPBOARD" end
def debug(&block); puts block.call if ENV['D'].present?; end

def parse(input)
  input
    .split("\n")
    .map { |l| l.split(/[: ]+/) }
    .map { |name, *rest| [name, rest] }
    .to_h
end

def monkey_result(monkeys, monkey)
  return monkeys[monkey].first.to_i if monkeys[monkey].length == 1

  left, operand, right = monkeys[monkey]
  monkey_result(monkeys, left).send(operand, monkey_result(monkeys, right))
end

def monkey_formula(monkeys, monkey)
  return monkey if monkey == 'humn'
  return monkeys[monkey].first.to_i if monkeys[monkey].length == 1

  left, operand, right = monkeys[monkey]
  left_value = monkey_formula(monkeys, left)
  right_value = monkey_formula(monkeys, right)
  if left_value.is_a?(Integer) && right_value.is_a?(Integer) && operand != '='
    left_value.to_i.send(operand, right_value.to_i)
  else
    [left_value, operand, right_value]
  end
end

INVERSE = { '+' => '-', '-' => '+', '*' => '/', '/' => '*' }
def solve_formula(formula, target)
  left, operand, right = formula

  inverse = INVERSE[operand]
  if operand == '+' || operand == '*'
    # commutative operations: no need to do anything special
    # 123 + (...) = 100
    if left.is_a?(Array)
      solve_formula(left, target.send(inverse, right))
    elsif right.is_a?(Array)
      solve_formula(right, target.send(inverse, left))
    elsif left == 'humn'
      target.send(inverse, right)
    elsif right == 'humn'
      target.send(inverse, left)
    end
  elsif operand == '-'
    if left.is_a?(Array)
      solve_formula(left, target.send(inverse, right))
    elsif right.is_a?(Array)
      # 123 - (...) = x
      # becomes:   (x - 123) * -1 = (...)
      solve_formula(right, (target - left) * -1)
    elsif left == 'humn'
      target.send(inverse, right)
    elsif right == 'humn'
      (target - left) * -1
    end
  elsif operand == '/'
    if left.is_a?(Array)
      solve_formula(left, target.send(inverse, right))
    elsif right.is_a?(Array)
      # 12 / (...) = x
      raise # not in input data, no need to handle
    elsif left == 'humn'
      target.send(inverse, right)
    elsif right == 'humn'
      raise # not in input data, no need to handle
    end
  end
end

def part1(monkeys)
  monkey_result(monkeys, 'root')
end

def part2(monkeys)
  monkeys['root'][1] = '='
  left, _, right = monkey_formula(monkeys, 'root')

  if left.is_a?(Array)
    solve_formula(left, right)
  else
    solve_formula(right, left)
  end
end

input = ARGF.read.chomp
#puts "PARSED: #{parse(input)}"

puts "Part 1:"
puts pbcopy(part1(parse(input)))

puts
puts "Part 2:"
puts pbcopy(part2(parse(input)))
