require 'set'
require 'bundler'; Bundler.require(:default)
def pbcopy(value); return if value.nil?; `/bin/bash -c 'echo -n "#{value}" | pbcopy'`; "#{value}    <- COPIED TO CLIPBOARD" end
def debug(&block); puts block.call if ENV['D'].present?; end

def parse(input)
  input
    .split("\n")
    .map { |l| l.split(' ') }
    .map { |l| [l[1], l[4].split('=').last.to_i, l[9..].map { |v| v.gsub(',', '') }] }
end

def max_flow(tunnels, valves, enabled = {}, position = 'AA', minute = 0, path = [])
  movement_options = tunnels[position].shuffle

  if minute == 30 || enabled.length == valves.length
    max = enabled.filter_map { |valve, minute| (30 - enabled[valve] + 1) * valves[valve] if enabled[valve] }.sum
    if max > 200
      puts path.join(", ")
      puts max
    end
    return max
  end

  max = 0
  if enabled[position].nil?
    max = max_flow(tunnels, valves, enabled.dup.tap { |e| e[position] = minute + 1 }, position, minute + 1, path.dup.append("Enable " + position))
  end

  max_by_moving = movement_options.map { |m| max_flow(tunnels, valves, enabled, m, minute + 1, path.dup.append("Move " + m)) }.max
  max = max_by_moving if max < max_by_moving

  max
end

def max_flow2(tunnels, valves, paths, position: 'AA', minute: 1, enabled: {})
  # heuristic: try to get to the best valves first
  best_valves = (valves.keys - enabled.keys).filter_map { |v| [v, valves[v] * (30 - paths[[position, v]])] if v != position }.sort_by(&:last).reverse
  if best_valves.none? && minute <= 30
    binding.pry if enabled['DD'] == 2
    return enabled.filter_map { |valve, minute| (30 - enabled[valve]) * valves[valve] }.sum
  end

  best_valves.map do |valve, _|
    distance = paths[[position, valve]]

    max_flow2(tunnels, valves, paths, position: valve, minute: minute + distance, enabled: enabled.merge(valve => minute + distance)) || 0
  end.max
end

def shortest_path(tunnels, src, dest, distance = 0, visited = [])
  return distance if src == dest

  (tunnels[src] - visited).filter_map { |t| shortest_path(tunnels, t, dest, distance + 1, visited + [src]) }.min
end

def part1(parsed)
  tunnels = parsed.map { |src, _flow, *tunnels| [src, tunnels.flatten] }.to_h
  valves = parsed.map { |src, flow| [src, flow] }.to_h
  paths = valves.keys.permutation(2).map { |src, dest| [[src, dest], shortest_path(tunnels, src, dest)] }.to_h
  enabled = valves.filter_map { |k, v| [k, 0] if v == 0 }.to_h
  binding.pry

  max_flow2(tunnels, valves, paths, enabled: enabled)
end

def part2(parsed)
end

input = ARGF.read.chomp
puts "PARSED: #{parse(input)}"

puts "Part 1:"
puts pbcopy(part1(parse(input)))

puts
puts "Part 2:"
puts pbcopy(part2(parse(input)))
