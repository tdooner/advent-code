def parse_input(input)
  rules = {}

  input.each do |line|
    outer, contents = line.split(' bags contain ')
    bags = contents[0..-2].split(', ')
    rules[outer] = bags.map do |bag_rule|
      if bag_rule == 'no other bags'
        [nil]
      elsif /(\d+) (.*) bags?/.match(bag_rule)
        [$~[1].to_i, $~[2]]
      else
        puts "no match: #{bag_rule.inspect}"
      end
    end
  end

  rules
end

def count_can_hold(rules, target_color)
  eligible_colors = [target_color]

  loop do
    valid_container_colors = rules.find_all do |outer, inner_bags|
      inner_bags.any? { |bag| eligible_colors.include?(bag[1]) }
    end.map(&:first)

    # stop when we don't find any new containers
    break if (valid_container_colors - eligible_colors).empty?

    eligible_colors |= valid_container_colors
  end

  eligible_colors - [target_color]
end

def total_bags_included(rules, target_color)
  rules[target_color].sum do |(count, inner_color)|
    next 0 if count == nil

    count * (total_bags_included(rules, inner_color) + 1)
  end
end

input = File.read(ARGV[0]).split(/\n/).map(&:strip)
rules = parse_input(input)

puts 'Part 1:'
puts count_can_hold(rules, 'shiny gold').count

puts 'Part 2:'
puts total_bags_included(rules, 'shiny gold')
