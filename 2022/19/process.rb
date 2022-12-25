require 'bundler'; Bundler.require(:default)
def pbcopy(&block); start = Time.now; value = block.call; return if value.nil?; `/bin/bash -c 'echo -n "#{value}" | pbcopy'`; puts "#{value}    <- COPIED TO CLIPBOARD (in #{Time.now - start}s)"; end
def debug(&block); puts block.call if ENV['D'].present?; end

Blueprint = Struct.new(:i, :ore_cost, :clay_ore_cost, :obsidian_ore_cost, :obsidian_clay_cost, :geode_ore_cost, :geode_obsidian_cost)
INITIAL_ROBOTS = { ore: 1, clay: 0, obsidian: 0, geode: 0 }
INITIAL_RESOURCES = { ore: 0, clay: 0, obsidian: 0, geode: 0 }
$FINAL_TURN = 24

class Hash
  def increment_by(hash, times: 1)
    self.dup.tap { |h| hash.each { |k, v| h[k] += (v * times) } }
  end

  def increment(key, n = 1)
    self.dup.tap { |h| h[key] += n }
  end

  def decrement(key, n = 1)
    self.dup.tap { |h| h[key] -= n }
  end
end

State = Struct.new(:blueprint, :turn, :robots, :resources) do

  def max_endgame_score
    # assume we buy geode robot each remaining turn? so on turn 21, the score
    # will be the current number plus 3 for the geode robot that comes online on
    # turn 22, 2 for the robot on turn 23, and 1 for the robot on 24.
    remaining_turns = ($FINAL_TURN - turn) # 24 - 21 = 3

    endgame_score + (remaining_turns * (remaining_turns + 1) / 2)
  end

  def endgame_score
    remaining_turns = ($FINAL_TURN - turn + 1)

    resources[:geode] + (robots[:geode] * remaining_turns)
  end

  def possibilities
    [].tap do |p|
      next_resources = resources.increment_by(robots)

      # save up for the next available ore bot
      turns_to_wait = [0, ((blueprint.ore_cost - resources[:ore].to_f) / robots[:ore]).ceil].max
      following_turn = turn + turns_to_wait + 1
      if following_turn <= $FINAL_TURN
        p << State.new(
          blueprint,
          following_turn,
          robots.increment(:ore),
          next_resources.decrement(:ore, blueprint.ore_cost).increment_by(robots, times: turns_to_wait)
        )
      end

      # save up for the next clay bot
      turns_to_wait = [0, ((blueprint.clay_ore_cost - resources[:ore].to_f) / robots[:ore]).ceil].max
      following_turn = turn + turns_to_wait + 1
      if following_turn <= $FINAL_TURN
        p << State.new(
          blueprint,
          following_turn,
          robots.increment(:clay),
          next_resources.decrement(:ore, blueprint.clay_ore_cost).increment_by(robots, times: turns_to_wait)
        )
      end

      # save up for obsidian bot
      if robots[:clay] >= 1
        turns_to_wait = [
          0,
          ((blueprint.obsidian_ore_cost - resources[:ore]) / robots[:ore].to_f).ceil,
          ((blueprint.obsidian_clay_cost - resources[:clay]) / robots[:clay].to_f).ceil
        ].max
        following_turn = turn + turns_to_wait + 1

        if following_turn <= $FINAL_TURN
          r = next_resources
            .decrement(:ore, blueprint.obsidian_ore_cost)
            .decrement(:clay, blueprint.obsidian_clay_cost)
            .increment_by(robots, times: turns_to_wait)

          p << State.new(
            blueprint,
            following_turn,
            robots.increment(:obsidian),
            r
          )
        end
      end

      # save up for geode bot
      if resources[:obsidian] >= 1
        turns_to_wait = [
          0,
          ((blueprint.geode_ore_cost - resources[:ore]) / robots[:ore].to_f).ceil,
          ((blueprint.geode_obsidian_cost - resources[:obsidian]) / robots[:obsidian].to_f).ceil
        ].max
        following_turn = turn + turns_to_wait + 1

        if following_turn <= $FINAL_TURN
          r = next_resources
            .decrement(:ore, blueprint.geode_ore_cost)
            .decrement(:obsidian, blueprint.geode_obsidian_cost)
            .increment_by(robots, times: turns_to_wait)

          p << State.new(
            blueprint,
            following_turn,
            robots.increment(:geode),
            r
          )
        end
      end
    end
  end
end

def parse(input)
  input
    .split("\n")
    .map do |l|
      p = l.split(' ').map(&:to_i)

      Blueprint.new(p[1], p[6], p[12], p[18], p[21], p[27], p[30])
    end
end

def part1(blueprints)
  blueprints.sum do |blueprint|
    debug { "Blueprint #{blueprint.i}" }
    states = [State.new(blueprint, 1, INITIAL_ROBOTS, INITIAL_RESOURCES)]
    max_geodes = 0

    while states.any?
      debug { "  Next step: #{states.length} states. Current best: #{max_geodes}" }

      max_geodes = [max_geodes, states.map(&:endgame_score).max].max
      next_states = filter_states(states, max_geodes).uniq.flat_map(&:possibilities)
      states = next_states
    end

    debug { "  Max Geodes: #{max_geodes}" }

    max_geodes * blueprint.i
  end
end

def filter_states(states, best_score)
  # remove any states that, if we do the greediest thing (buying a geode robot
  # every turn) will still be inferior to the best known state
  states.keep_if { |s| best_score < s.max_endgame_score }
end

def part2(blueprints)
  $FINAL_TURN = 32

  blueprints.first(3).map do |blueprint|
    debug { "Blueprint #{blueprint.i}" }
    states = [State.new(blueprint, 1, INITIAL_ROBOTS, INITIAL_RESOURCES)]
    max_geodes = 0

    while states.any?
      debug { "  Next step: #{states.length} states. Current best: #{max_geodes}" }

      max_geodes = [max_geodes, states.map(&:endgame_score).max].max
      next_states = filter_states(states, max_geodes).uniq.flat_map(&:possibilities)
      states = next_states
    end

    debug { "  Max Geodes: #{max_geodes}" }

    max_geodes
  end.reduce(:*)
end

parsed = parse(ARGF.read.chomp)
#puts "PARSED: #{parsed.inspect}"

puts "Part 1:"
pbcopy { part1(parsed) }

puts
puts "Part 2:"
pbcopy { part2(parsed) }
