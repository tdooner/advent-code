require 'set'
require 'bundler'; Bundler.require(:default)
def pbcopy(&block); start = Time.now; value = block.call; return if value.nil?; `/bin/bash -c 'echo -n "#{value}" | pbcopy'`; puts "#{value}    <- COPIED TO CLIPBOARD (in #{Time.now - start}s)"; end
def debug(&block); puts block.call if ENV['D'].present?; end

def parse(input)
  input
    .split("\n")
    .map { |l| l.split(' ') }
    .map { |l| [l[1], l[4].split('=').last.to_i, l[9..].map { |v| v.gsub(',', '') }] }
end

# Attempt at abstracting a common BFS-based problem solver
class BFSSearcher
  def initialize(state, end_turn)
    @states = [state]
    @end_turn = end_turn
  end

  def maximize(method, filter_method: nil)
    current_max = 0

    while @states.any?
      debug { "  Current step: #{@states.length} states. Current best: #{current_max}" }

      current_max = [current_max, @states.map { |s| s.send(method, @end_turn) }.max].max
      @states = @states.keep_if { |s| s.send(filter_method, @end_turn) >= current_max } if filter_method
      next_states = @states.flat_map(&:possibilities)
      @states = next_states
    end

    debug { "  Final Max: #{current_max}" }
    current_max
  end
end

State = Struct.new(:turn, :valves, :paths, :enabled_valves, :position) do
  def possibilities
    (valves.keys - enabled_valves.keys).map do |valve_to_enable|
      next_turn = turn + paths[[position, valve_to_enable]] + 1

      State.new(next_turn, valves, paths, enabled_valves.dup.tap { |h| h[valve_to_enable] = next_turn }, valve_to_enable)
    end
  end

  def total_flow(end_turn)
    enabled_valves.sum do |valve, turn_enabled|
      (end_turn - turn_enabled + 1) * valves[valve]
    end
  end

  def max_total_flow(end_turn)
    # if all remaining pipes were opened immediately, how much flow they'd have
    total_flow(end_turn) + (valves.keys - enabled_valves.keys).sum do |valve_to_enable|
      (end_turn - turn + 1) * valves[valve_to_enable]
    end
  end
end

def shortest_path(tunnels, src, dest, distance = 0, visited = [])
  return distance if src == dest

  (tunnels[src] - visited).filter_map { |t| shortest_path(tunnels, t, dest, distance + 1, visited + [src]) }.min
end

def part1(parsed)
  tunnels = parsed.map { |src, _flow, *tunnels| [src, tunnels.flatten] }.to_h
  valves = parsed.map { |src, flow| [src, flow] }.to_h
  debug { "Computing shortest paths..." }
  paths = valves.keys.permutation(2).map { |src, dest| [[src, dest], shortest_path(tunnels, src, dest)] }.to_h
  enabled = valves.filter_map { |k, v| [k, 0] if v == 0 }.to_h

  start = State.new(1, valves, paths, enabled, 'AA')
  BFSSearcher
    .new(start, 30)
    .maximize(:total_flow, filter_method: :max_total_flow)
end

def part2(parsed)
end

input = ARGF.read.chomp
#puts "PARSED: #{parse(input)}"

puts "Part 1:"
pbcopy { part1(parse(input)) }

puts
puts "Part 2:"
pbcopy { part2(parse(input)) }
