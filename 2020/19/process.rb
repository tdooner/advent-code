require 'pry'
rules, messages = $<.read.split("\n\n")
rules = Hash[rules.each_line.map { |r| r.strip.split(': ') }]
messages = messages.each_line.map { |m| m.strip }

MAX_MESSAGE_LENGTH = messages.map(&:length).max

def evaluate_rule(rules, id, remain = MAX_MESSAGE_LENGTH)
  rule = rules[id]

  if rule.include?("\"")
    [rule[1], 1]
  elsif rule.include?(" | ")
    if remain <= 0
      return ['', 0]
    end

    left, right = rule.split(" | ")
    left_remaining = remain
    left_min_consumed = MAX_MESSAGE_LENGTH
    left_rules = left.split.map do |r|
      rule, consumed = evaluate_rule(rules, r, left_remaining)
      left_remaining -= consumed
      left_min_consumed = [left_min_consumed, consumed].min
      rule
    end

    right_remaining = remain
    right_min_consumed = MAX_MESSAGE_LENGTH
    right_rules = right.split.map do |r|
      rule, consumed = evaluate_rule(rules, r, right_remaining)
      right_remaining -= consumed
      right_min_consumed = [right_min_consumed, consumed].min
      rule
    end

    [
      Regexp.union(
        Regexp.new(left_rules.join),
        Regexp.new(right_rules.join)
      ),
      left_min_consumed + right_min_consumed
    ]
  else
    total_consumed = 0
    inner = rule.split.map do |r|
      rule, consumed = evaluate_rule(rules, r, remain)
      remain -= consumed
      total_consumed += consumed
      rule
    end

    [Regexp.new(inner.join), total_consumed]
  end
end

def solve(rules, messages)
  regex, _ = evaluate_rule(rules, "0")
  messages.count { |m| m.match?(/\A#{regex}\Z/) }
end

def solve2(rules, messages)
  puts "  Creating gnarly regex..."
  regex, _ = evaluate_rule(rules, "0")
  puts "    now you have two problems: it's #{regex.to_s.length} characters long!"
  messages.each_with_index.count do |m, i|
    puts "  testing message #{i} / #{messages.length}"
    m.match?(/\A#{regex}\Z/)
  end
end

puts 'Part 1:'
puts solve(rules, messages)

puts 'Part 2:'
rules['8'] = '42 | 42 8'
rules['11'] = '42 31 | 42 11 31'
puts solve2(rules, messages)
