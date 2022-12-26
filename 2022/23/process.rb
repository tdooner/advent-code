require 'bundler'; Bundler.require(:default)
def pbcopy(value); return if value.nil?; `/bin/bash -c 'echo -n "#{value}" | pbcopy'`; "#{value}    <- COPIED TO CLIPBOARD" end
def debug(&block); puts block.call if ENV['D'].present?; end

def parse(input)
  input
    .split("\n")
    .each_with_index
    .map { |l, row| l.chars.each_with_index.map { |c, col| [[row, col], c] } }
    .flatten(1)
    .filter_map { |(r, c), v| [r, c] if v == '#' }
    .to_set
end

def print(game)
  min_row, max_row = game.map(&:first).minmax
  min_col, max_col = game.map(&:last).minmax
  (min_row - 1..max_row + 1).map do |r|
    (min_col - 1..max_col + 1).map do |c|
      game.include?([r, c]) ? '#' : '.'
    end.join
  end.join("\n")
end

def empty_tiles(game)
  min_row, max_row = game.map(&:first).minmax
  min_col, max_col = game.map(&:last).minmax

  (max_col - min_col + 1) * (max_row - min_row + 1) - game.length
end

def perform_turn(game, turn = 0)
  next_moves = {} # new coords => old coords
  game.each do |elf|
    r, c = elf
    n = [r - 1, c]; nw = [r - 1, c - 1]; ne = [r - 1, c + 1]
    s = [r + 1, c]; se = [r + 1, c + 1]; sw = [r + 1, c - 1]
    w = [r, c - 1]; e = [r, c + 1]


    # if elf has no neighbors, do nothing as the the elf does not move
    next if game.disjoint?(Set[n, nw, ne, s, se, sw, w, e])

    # we rotate which attempted move we should try first
    attempted_moves = [
      # take the first value (according to the rotation logic) where the first key is true:
      # [valid?, move]
      [game.exclude?(n) && game.exclude?(ne) && game.exclude?(nw), n],
      [game.exclude?(s) && game.exclude?(se) && game.exclude?(sw), s],
      [game.exclude?(w) && game.exclude?(nw) && game.exclude?(sw), w],
      [game.exclude?(e) && game.exclude?(ne) && game.exclude?(se), e]
    ]
    valid_attempt = 4.times.find { |i| attempted_moves[(turn + i) % attempted_moves.length].first }
    next unless valid_attempt

    next_move = attempted_moves[(turn + valid_attempt) % attempted_moves.length].last
    if next_moves.include?(next_move)
      next_moves[next_move] = nil
    else
      next_moves[next_move] = elf
    end
  end

  moved_elves = next_moves.compact
  (game - moved_elves.values) + moved_elves.keys
end

def part1(game)
  10.times do |turn|
    game = perform_turn(game, turn)
  end

  empty_tiles(game)
end

def part2(game)
  turn = 0
  loop do
    next_state = perform_turn(game, turn)
    turn += 1
    break if next_state == game
    game = next_state
  end

  turn
end

input = ARGF.read.chomp
debug { "PARSED: #{parse(input)}" }

puts "Part 1:"
puts pbcopy(part1(parse(input)))

puts
puts "Part 2:"
puts pbcopy(part2(parse(input)))
