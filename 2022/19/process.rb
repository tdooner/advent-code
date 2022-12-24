require 'bundler'; Bundler.require(:default)
def pbcopy(&block); start = Time.now; value = block.call; return if value.nil?; `/bin/bash -c 'echo -n "#{value}" | pbcopy'`; puts "#{value}    <- COPIED TO CLIPBOARD (in #{Time.now - start}s)"; end
def debug(&block); puts block.call if ENV['D'].present?; end

Blueprint = Struct.new(:i, :ore_cost, :clay_ore_cost, :obsidian_ore_cost, :obsidian_clay_cost, :geode_ore_cost, :geode_obsidian_cost)
INITIAL_ROBOTS = { ore: 1, clay: 0, obsidian: 0, geode: 0 }
INITIAL_RESOURCES = { ore: 0, clay: 0, obsidian: 0, geode: 0 }

class Hash
  def increment_by(hash)
    self.dup.tap { |h| hash.each { |k, v| h[k] += v } }
  end

  def increment(key, n = 1)
    self.dup.tap { |h| h[key] += n }
  end

  def decrement(key, n = 1)
    self.dup.tap { |h| h[key] -= n }
  end
end

def filter_states(states)
  # remove any states that, if we do the greediest thing (buying a geode robot
  # every turn) will still be inferior to another known state where we do
  # nothing.
  geodes_when_we_do_nothing = states.map(&:min_endgame_score).max

  states.keep_if { |s| geodes_when_we_do_nothing < s.max_endgame_score }
end

State = Struct.new(:blueprint, :turn, :robots, :resources) do
  def max_endgame_score
    # assume we buy geode robot each remaining turn? so on turn 21, the score
    # will be the current number plus 3 for the geode robot that comes online on
    # turn 22, 2 for the robot on turn 23, and 1 for the robot on 24.
    remaining_turns = (24 - turn) # 24 - 21 = 3

    min_endgame_score + (remaining_turns * (remaining_turns + 1) / 2)
  end

  def min_endgame_score
    # assume we do nothing, how many geodes will we have?
    remaining_turns = (24 - turn)

    resources[:geode] + robots[:geode] * remaining_turns
  end

  def possibilities
    [].tap do |p|
      next_resources = resources.increment_by(robots)

      p << State.new(blueprint, turn + 1, robots, next_resources)
      if resources[:ore] >= blueprint.ore_cost
        p << State.new(blueprint, turn + 1, robots.increment(:ore), next_resources.decrement(:ore, blueprint.ore_cost))
      end
      if resources[:ore] >= blueprint.clay_ore_cost
        p << State.new(blueprint, turn + 1, robots.increment(:clay), next_resources.decrement(:ore, blueprint.clay_ore_cost))
      end
      if resources[:ore] >= blueprint.obsidian_ore_cost && resources[:clay] >= blueprint.obsidian_clay_cost
        r = next_resources.decrement(:ore, blueprint.obsidian_ore_cost).decrement(:clay, blueprint.obsidian_clay_cost)
        p << State.new(blueprint, turn + 1, robots.increment(:obsidian), r)
      end
      if resources[:ore] >= blueprint.geode_ore_cost && resources[:obsidian] >= blueprint.geode_obsidian_cost
        r = next_resources.decrement(:ore, blueprint.geode_ore_cost).decrement(:obsidian, blueprint.geode_obsidian_cost)
        p << State.new(blueprint, turn + 1, robots.increment(:geode), r)
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
    states = [State.new(blueprint, 1, INITIAL_ROBOTS, INITIAL_RESOURCES)]
    loop do
      debug { "  Beginning turn #{states.first.turn} - length: #{states.length}" }
      break if states.first.turn == 24

      states = filter_states(states).flat_map(&:possibilities).uniq
    end

    max_geodes = states.map { |s| s.resources[:geode] + s.robots[:geode] }.max
    debug { "  Blueprint #{blueprint.i} - Max Geodes: #{max_geodes}" }

    max_geodes * blueprint.i
  end
end

def part2(blueprints)
end

parsed = parse(ARGF.read.chomp)
#puts "PARSED: #{parsed.inspect}"

puts "Part 1:"
pbcopy { part1(parsed) }

puts
puts "Part 2:"
pbcopy { part2(parsed) }
