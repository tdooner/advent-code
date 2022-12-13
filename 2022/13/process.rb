require 'bundler'; Bundler.require(:default)
def pbcopy(value); return if value.nil?; `/bin/bash -c 'echo -n "#{value}" | pbcopy'`; "#{value}    <- COPIED TO CLIPBOARD" end
def debug(&block); return unless ENV['D']; puts block.call; end

def parse(input)
  input.split("\n\n").map { |i| i.lines.map { |l| eval l } }
end

def in_order?(left, right, left_i = 0, right_i = 0, depth = 1)
  left_val = left[left_i]
  right_val = right[right_i]
  return nil if left_val.nil? && right_val.nil?

  debug { ('  ' * depth) + "- Compare #{left_val.inspect} vs #{right_val.inspect}" }

  return true if left_val.nil? && !right_val.nil?
  return false if right_val.nil?

  if left_val.is_a?(Integer) && right_val.is_a?(Integer)
    if left_val < right_val
      true
    elsif left_val > right_val
      false
    else
      in_order?(left, right, left_i + 1, right_i + 1, depth)
    end
  elsif left_val.is_a?(Array) && right_val.is_a?(Array)
    decision = in_order?(left_val, right_val, 0, 0, depth + 1)
    return decision unless decision.nil?

    in_order?(left, right, left_i + 1, right_i + 1, depth)
  elsif left_val.is_a?(Integer) && right_val.is_a?(Array)
    decision = in_order?([left_val], right_val, 0, 0, depth + 1)
    return decision unless decision.nil?

    in_order?(left, right, left_i + 1, right_i + 1, depth)
  elsif left_val.is_a?(Array) && right_val.is_a?(Integer)
    decision = in_order?(left_val, [right_val], 0, 0, depth + 1)
    return decision unless decision.nil?

    in_order?(left, right, left_i + 1, right_i + 1, depth)
  end
end

def part1(parsed)
  parsed.each_with_index.map do |(left, right), i|
    debug { "START #{i + 1}" }
    debug { "Compare #{left.inspect} vs #{right.inspect}" }
    if in_order?(left, right)
      debug { puts "IN ORDER: #{i + 1}" }

      i + 1
    end
  end.compact.sum
end

def part2(parsed)
  dividers = [[[2]], [[6]]]

  sorted = (parsed.flatten(1) + dividers).sort do |left, right|
    in_order?(left, right) ? -1 : 1
  end

  (1 + sorted.index(dividers.first)) * (1 + sorted.index(dividers.last))
end

parsed = parse(ARGF.read.chomp)
#puts "PARSED: #{parsed.inspect}"

puts "Part 1:"
puts pbcopy(part1(parsed))

puts
puts "Part 2:"
puts pbcopy(part2(parsed))
