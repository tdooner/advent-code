require 'bundler'; Bundler.require(:default)
def pbcopy(value); return if value.nil?; `/bin/bash -c 'echo -n "#{value}" | pbcopy'`; "#{value}    <- COPIED TO CLIPBOARD" end

Monkey = Struct.new(:items, :operation, :test, :monkey_if_true, :monkey_if_false, :inspections)

def parse(input)
  input.split("\n\n").map do |i|
    Monkey.new(
      i.lines[1].strip.split(': ').last.split(', ').map(&:to_i),
      i.lines[2].strip.split(': new = old ').last.split(' '),
      i.lines[3].strip.split(': divisible by ').last.to_i,
      i.lines[4].strip.match(/monkey (\d+)/)[1].to_i,
      i.lines[5].strip.match(/monkey (\d+)/)[1].to_i,
      0
    )
  end
end

def part1(monkeys)
  20.times do |round|
    monkeys.each do |monkey|
      while (item = monkey.items.shift)
        monkey.inspections += 1
        operator, operand = monkey.operation
        operand = (operand == 'old') ? item : operand.to_i
        new_item = item.send(operator, operand) / 3

        if new_item % monkey.test == 0
          monkeys[monkey.monkey_if_true].items.push(new_item)
        else
          monkeys[monkey.monkey_if_false].items.push(new_item)
        end
      end
    end
  end

  monkeys.map(&:inspections).sort.reverse.first(2).inject(:*)
end

def part2(monkeys)
  common_divisor = monkeys.map(&:test).reduce(:*)

  10_000.times do |round|
    monkeys.each do |monkey|
      while (item = monkey.items.shift)
        monkey.inspections += 1
        operator, operand = monkey.operation
        operand = (operand == 'old') ? item : operand.to_i
        new_item = item.send(operator, operand) % common_divisor

        if new_item % monkey.test == 0
          monkeys[monkey.monkey_if_true].items.push(new_item)
        else
          monkeys[monkey.monkey_if_false].items.push(new_item)
        end
      end
    end
  end

  monkeys.map(&:inspections).sort.reverse.first(2).inject(:*)
end

input = ARGF.read.chomp
# puts "PARSED: #{parse(input)}"

puts "Part 1:"
puts pbcopy(part1(parse(input)))

puts
puts "Part 2:"
puts pbcopy(part2(parse(input)))
