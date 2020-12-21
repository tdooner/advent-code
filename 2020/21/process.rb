require 'pry'
input = $<.map { |l| l.strip.split("(contains ") }
#input = $<.read.split("\n\n")

def solve(input, part = :p1)
  all_recipes = input.map do |line|
    ingredients = line[0].split
    allergens = line[1][0..-2].split(', ')
    [ingredients, allergens]
  end

  might_be = {}
  all_allergens = all_recipes.map(&:last).flatten.uniq
  all_recipes.each do |ing, allerg|
    allerg.each do |allergen|
      might_be[allergen] ||= ing
      might_be[allergen] &= ing
    end
  end

  solved = []
  while (sure_bets = might_be.find { |k, v| !solved.include?(k) && v.length == 1 })
    solved << sure_bets[0]
    might_be.keys.each do |k|
      next if k == sure_bets[0]
      might_be[k].delete(sure_bets[1][0])
    end
  end

  if part == :p1
    all_words = all_recipes.map(&:first).flatten.uniq
    (all_words - might_be.values.map(&:first)).sum do |allergen|
      all_recipes.sum { |ingredients, _| ingredients.count(allergen) }
    end
  elsif part == :p2
    might_be.sort_by { |k, v| k }.map(&:last).join(',')
  end
end

puts 'Part 1:'
puts solve(input)

puts 'Part 2:'
puts solve(input, :p2)
