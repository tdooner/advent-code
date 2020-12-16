require 'pry'
input = $<.read
rules, ticket, nearby = input.split("\n\n")

rules =
  Hash[rules.split("\n").map { |l| l.split(': ') }.map { |k, v| [k, v.split(' or ').map { |range| min, max = range.split('-').map(&:to_i); (min..max) }] }]
ticket = ticket.split("\n")[1].split(',').map(&:to_i)
nearby = nearby.split("\n")[1..-1].map { |l| l.split(',').map(&:to_i) }

def solve(rules, ticket, nearby)
  invalid_tickets = nearby.map do |values|
    values.find { |value| rules.none? { |_k, v| v[0].include?(value) || v[1].include?(value) } }
  end.compact
  puts 'invalid:'
  invalid_tickets.sum
end

def solve2(rules, ticket, nearby)
  # find & remove invalid tickets
  invalid_tickets = nearby.find_all do |values|
    values.find { |value| rules.none? { |_k, v| v[0].include?(value) || v[1].include?(value) } }
  end
  nearby = nearby - invalid_tickets

  # find all possible fields for each index on the tickets
  possibilities = Hash[(0...nearby[0].length).map do |field_num|
    values = nearby.map { |t| t[field_num] }
    matches_rules = rules.find_all do |rule_name, (r1, r2)|
      values.all? { |v| r1.include?(v) || r2.include?(v) }
    end.map(&:first)

    [field_num, matches_rules]
  end]

  # Loop over fields, finding any that have been narrowed down to only a
  # single field. After picking it, remove it from any other possible fields.
  # Conveniently, this works for the input data.
  solved = []
  loop do
    must_be = possibilities.find { |k, v| v.length == 1 && !solved.include?(k) }
    break unless must_be
    possibilities.each do |k, v|
      next if k == must_be[0]
      v.delete(must_be[1][0])
    end
    solved << must_be[0]
  end

  # The indices of the fields with 'departure' are the ones for the problem
  indices = possibilities.find_all { |k, v| v[0].include?('departure') }.map(&:first)
  ticket.values_at(*indices).reduce(1, :*)
end

puts 'Part 1:'
puts solve(rules, ticket, nearby)

puts 'Part 2:'
puts solve2(rules, ticket, nearby)
