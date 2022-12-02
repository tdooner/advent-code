plays = ARGF.read.split("\n")

SCORES = {
  # opponent, us => shape + outcome
  #
  # Shape:   Rock = 1, Paper = 2, Scissors = 3
  # Outcome: Win = 6, Draw = 3, Lose = 0
  'A X' => 1 + 3,
  'A Y' => 2 + 6,
  'A Z' => 3 + 0,
  'B X' => 1 + 0,
  'B Y' => 2 + 3,
  'B Z' => 3 + 6,
  'C X' => 1 + 6,
  'C Y' => 2 + 0,
  'C Z' => 3 + 3,
}

puts "Part 1:"
puts plays.sum { |play| SCORES[play] }

SCORES_TWO = {
  # A = Opponent plays Rock, B = Paper, C = Scissors
  # X = We lose, Y = Tie, Z = Win
  #
  #       => shape + outcome
  'A X' => 3 + 0,
  'A Y' => 1 + 3,
  'A Z' => 2 + 6,
  'B X' => 1 + 0,
  'B Y' => 2 + 3,
  'B Z' => 3 + 6,
  'C X' => 2 + 0,
  'C Y' => 3 + 3,
  'C Z' => 1 + 6,
}

puts "Part 2:"
puts plays.sum { |play| SCORES_TWO[play] }
