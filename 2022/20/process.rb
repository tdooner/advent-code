require 'bundler'; Bundler.require(:default)
def pbcopy(value); return if value.nil?; `/bin/bash -c 'echo -n "#{value}" | pbcopy'`; "#{value}    <- COPIED TO CLIPBOARD" end
def debug(&block); puts block.call if ENV['D'].present?; end

def parse(input)
  input.split("\n").map(&:to_i)
end

def mix(numbers, iterations: 1)
  mixed = numbers.dup
  original_positions = numbers.each_with_index.map { |num, i| [num, i, i] }

  iterations.times do
    positions = original_positions.map(&:dup)

    while (num, index, original_index = positions.shift)
      new_index = (index + num) % (mixed.length - 1)

      debug { "Moving #{num} from #{index} -> #{new_index}" }

      mixed.delete_at(index)
      mixed.insert(new_index, num)

      if index < new_index
        # item was moved forwards, we have to decrement the original location of
        # any item that was in between
        positions.each { |a| a[1] -= 1 if index < a[1] && a[1] <= new_index }
        original_positions.each { |a| a[1] -= 1 if index < a[1] && a[1] <= new_index }
      elsif new_index < index
        # item was moved backwards, we have to increment the original location of
        # any item that was in between
        positions.each { |a| a[1] += 1 if new_index <= a[1] && a[1] < index }
        original_positions.each { |a| a[1] += 1 if new_index <= a[1] && a[1] < index }
      end

      original_positions[original_index][1] = new_index
    end
  end

  mixed
end

def part1(numbers)
  mixed = mix(numbers)

  mixed[(mixed.index(0) + 1000) % mixed.length] +
    mixed[(mixed.index(0) + 2000) % mixed.length] +
    mixed[(mixed.index(0) + 3000) % mixed.length]
end

def part2(numbers)
  numbers = numbers.map { |n| n * 811589153 }
  mixed = mix(numbers, iterations: 10)

  mixed[(mixed.index(0) + 1000) % mixed.length] +
    mixed[(mixed.index(0) + 2000) % mixed.length] +
    mixed[(mixed.index(0) + 3000) % mixed.length]
end

input = ARGF.read.chomp
#puts "PARSED: #{parse(input)}"

puts "Part 1:"
puts pbcopy(part1(parse(input)))

puts
puts "Part 2:"
puts pbcopy(part2(parse(input)))
