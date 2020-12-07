def parse_input(input)
  rules = {}

  input.each do |line|
    outer, contents = line.split(' bags contain ')
    bags = contents[0..-2].split(', ')
    rules[outer] = bags.map do |bag_rule|
      if bag_rule == 'no other bags'
        []
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
    puts eligible_colors.inspect
    containing_colors = Hash[rules.find_all { |k, v| v.any? { |valid_color| eligible_colors.include?(valid_color[1]) } }].map(&:first)

    break if (eligible_colors & containing_colors).length == containing_colors.length

    eligible_colors |= containing_colors
  end

  eligible_colors - [target_color]
end

def total_bags_included(rules, target_color)
  rules[target_color].sum do |(count, inner_color)|
    next 0 unless inner_color

    count * (total_bags_included(rules, inner_color) + 1)
  end
end

input = File.read(ARGV[0]).split(/\n/).map(&:strip)
rules = parse_input(input)

puts 'Part 1:'
puts count_can_hold(rules, 'shiny gold').count

puts 'Part 2:'
puts total_bags_included(rules, 'shiny gold')
