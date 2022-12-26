require 'bundler'; Bundler.require(:default)
def pbcopy(value); return if value.nil?; `/bin/bash -c 'echo -n "#{value}" | pbcopy'`; "#{value}    <- COPIED TO CLIPBOARD" end
def debug(&block); puts block.call if ENV['D'].present?; end

DIRECTIONS = { '>' => [0, 1], '<' => [0, -1], 'v' => [1, 0], '^' => [-1, 0] }
Map = Struct.new(:start, :target, :max_row, :max_col) do
  def self.from_input(input)
    max_row = input.keys.map { |r, c| r }.max
    max_col = input.keys.map { |r, c| c }.max

    new(
      input.find { |(r, _), char| r == 0 && char == '.' }.first,
      input.find { |(r, _), char| r == max_row && char == '.' }.first,
      max_row,
      max_col
    )
  end

  def valid?(coord)
    # within bounds? OR target?
    (1 <= coord[0] && coord[0] < max_row && 1 <= coord[1] && coord[1] < max_col) ||
      (coord[0] == target[0] && coord[1] == target[1])
  end

  def wrap(row, col)
    if row < 1
      row = max_row - 1
    elsif row >= max_row
      row = 1
    end

    if col < 1
      col = max_col - 1
    elsif col >= max_col
      col = 1
    end

    [row, col]
  end

  def inspect(player, blizzards)
    (0..max_row).map do |row|
      (0..max_col).map do |col|
        if [row, col] == player
          'E'
        elsif row == 0 || row == max_row || col == 0 || col == max_col
          if [row, col] == start || [row, col] == target
            '.'
          else
            '#'
          end
        else
          b = blizzards.find_all { |(r, c), _| row == r && col == c }
          if b.length == 0
            '.'
          elsif b.length == 1
            b.first.last
          else
            b.length.to_s
          end
        end
      end.join
    end.join("\n")
  end

  def move_blizzards(blizzards)
    blizzards.map do |(r, c), dir|
      d = DIRECTIONS[dir]
      [wrap(r + d[0], c + d[1]), dir]
    end
  end
end

# Attempt at abstracting a common BFS-based problem solver
class BFSSearcher
  def initialize(state)
    @start = state
    @states = Containers::PriorityQueue.new
    @states.push(state, -1 * state.min_score(0))
    @min_turn = { state => 0 }
    @prev = {}
  end

  def minimize
    examined = 0
    while (state = @states.pop)
      examined += 1

      debug { "Examined #{examined} states, #{@states.size} remain. Current Turn: #{@min_turn[state]}. Distance Left: #{state.min_score(0)}." } if examined % 1000 == 0

      if state.goal?
        path = reconstruct_path(state)
        debug { "Found shortest path (cost = #{path.length}) in #{examined} examinations." }
        return path
      end

      state.possibilities.each do |next_state|
        turn = @min_turn[state] + 1
        if turn < @min_turn.fetch(next_state, Float::INFINITY)
          @prev[next_state] = state
          @min_turn[next_state] = turn

          @states.push(next_state, -1 * next_state.min_score(turn))
        end
      end
    end
    raise "No path found after examining #{examined}."
  end

  def reconstruct_path(state)
    return [] if state == @start

    reconstruct_path(@prev[state]) << state
  end
end

State = Struct.new(:mapp, :player, :blizzards) do
  def min_score(turn)
    turn + (mapp.target[0] - player[0]).abs + (mapp.target[1] - player[1]).abs
  end

  def goal?
    player == mapp.target
  end

  def possibilities
    p = []

    next_blizzards = mapp.move_blizzards(blizzards)
    blizzard_coords = next_blizzards.map(&:first).to_set

    # stay put
    unless blizzard_coords.include?(player)
      p << State.new(mapp, player, next_blizzards)
    end

    DIRECTIONS.each do |_, (dr, dc)|
      next_player = [player[0] + dr, player[1] + dc]

      next unless mapp.valid?(next_player)
      next if blizzard_coords.include?(next_player)

      p << State.new(mapp, next_player, next_blizzards)
    end

    p
  end

  def inspect
    mapp.inspect(player, blizzards)
  end
end

def parse(input)
  # common pattern: parse map into (row, col) coordinates
  input
    .split("\n")
    .each_with_index
    .map { |line, r| line.chars.each_with_index.map { |char, c| [[r, c], char] } }
    .flatten(1)
    .to_h
end

def solve(input)
  start = Time.now
  puts "Part 1:"

  map = Map.from_input(input)
  blizzards = input.find_all { |_, v| v != '#' && v != '.' }.to_h
  state = State.new(map, map.start, blizzards)
  solver = BFSSearcher.new(state)
  path_there = solver.minimize
  puts pbcopy(path_there.length)
  puts "(took #{((Time.now - start) / 60).round(2)} min)"

  puts "Part 2:"
  start = Time.now
  # path back
  state = path_there.last.dup
  new_start, new_target = state.mapp.target, state.mapp.start
  state.mapp.start, state.mapp.target = new_start, new_target
  solver = BFSSearcher.new(state)
  path_back = solver.minimize

  # path there again
  state = path_back.last.dup
  new_start, new_target = state.mapp.target, state.mapp.start
  state.mapp.start, state.mapp.target = new_start, new_target
  solver = BFSSearcher.new(state)
  path_back_again = solver.minimize
  puts "(took #{((Time.now - start) / 60).round(2)} min)"

  puts pbcopy(path_there.length + path_back.length + path_back_again.length)
end

input = ARGF.read.chomp
#debug { "PARSED: #{parse(input)}" }

solve(parse(input))
