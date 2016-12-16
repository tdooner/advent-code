require 'set'
require_relative './parse-input.rb'

class Searcher
  def initialize(state)
    @state = state
  end

  def solve!
    states = Set.new([@state])
    seen_states = Set.new

    loop do
      $stderr.puts "processing #{states.length} states"
      if final_state = states.detect { |s| s.closeness_to_goal == 0 }
        return final_state
      end

      seen_states = seen_states.merge(states)
      next_states = Set.new
      states = states.to_a
      while state = states.pop
        next_states = next_states.merge(state.each_move)
      end

      states = next_states - seen_states

      raise 'Ran out of states?!' if states.none?
    end
  end
end

class State
  attr_reader :previous_state

  def initialize(floor_contents, previous_state)
    @floor_contents = floor_contents
    @previous_state = previous_state
  end

  def valid?
    @floor_contents.none? { |floor| will_a_microchip_fry?(floor) }
  end

  def closeness_to_goal
    total_distance = 0

    @floor_contents.each_with_index do |floor, i|
      floors_away = (@floor_contents.length - 1) - i
      total_distance += floor.length * floors_away
    end

    total_distance
  end

  # @param {Proc} block The block which will receive new states for each valid
  #   next state.
  def each_move(&block)
    return to_enum(:each_move) unless block_given?

    elevator_floor = @floor_contents.find_index { |f| f.any?(&:elevator?) }
    possible_floors = []

    # if the elevator can move down
    if elevator_floor > 0
      possible_floors << elevator_floor - 1
    end

    # if the elevator can move up
    if elevator_floor < @floor_contents.length - 1
      possible_floors << elevator_floor + 1
    end

    possible_floors.each do |next_floor|
      (
        @floor_contents[elevator_floor].reject(&:elevator?).combination(1).to_a +
        @floor_contents[elevator_floor].reject(&:elevator?).combination(2).to_a
      ).each do |item1, item2|
        new_state = @floor_contents.map(&:dup)

        # first move the elevator up
        new_state[elevator_floor].delete_if(&:elevator?)
        new_state[next_floor] << Item.new(:elevator)

        # then move item 1
        new_state[elevator_floor].delete_if { |i| i == item1 }
        new_state[next_floor] << item1

        # then move item 2 (if necessary)
        if item2
          new_state[elevator_floor].delete_if { |i| i == item2 }
          new_state[next_floor] << item2
        end

        state = State.new(new_state, self)
        yield state if state.valid?
      end
    end
  end

  def to_s
    contents = @floor_contents.dup

    elevator_floor = contents.find_index { |f| f.any?(&:elevator?) }
    elevator_floor_num = elevator_floor + 1

    elements = contents.flatten.map { |i| i.element }.compact.uniq

    contents.reverse.each_with_index.map do |floor, i|
      num = contents.length - i
      element_contents = []

      elements.each do |element|
        {
          # type => abbreviation
          generator: 'G',
          microchip: 'M',
        }.each do |type, abbreviation|
          if floor.any? { |item| item.type == type && item.element == element }
            element_contents << "#{element[0].upcase}#{abbreviation}"
          else
            element_contents << '.'
          end
        end
      end

      "F%-2s %-3s#{' %-3s' * elements.length * 2}" % [
        num,
        num == elevator_floor_num ? 'E' : '.'
      ].concat(element_contents)
    end.join("\n")
  end

  def hash
    @floor_contents.map(&:sort).map(&:hash).hash
  end

  def eql?(other)
    other.is_a?(State) && other.hash == self.hash
  end

  private

  def will_a_microchip_fry?(floor)
    generators = floor.find_all { |item| item.generator? }

    # nothing fries unless there are generators on the floor
    return false if generators.none?

    unpowered_microchips = floor.find_all do |item|
      item.microchip? && floor.none? do |other|
        other.generator? && other.element == item.element
      end
    end

    return unpowered_microchips.any?
  end
end

state = State.new(parse_input(ARGF), nil)

end_state = Searcher.new(state).solve!
steps = 0
while end_state.previous_state
  end_state = end_state.previous_state
  steps += 1
end

puts steps
