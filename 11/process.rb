require_relative './parse-input.rb'

class State
  def initialize(floor_contents)
    @floor_contents = floor_contents
  end

  def valid?
  end

  def to_s
    contents = @floor_contents.dup

    elevator_floor = contents.find_index { |f| f.any? { |i| i[:type] == :elevator } }
    elevator_floor_num = elevator_floor + 1

    elements = contents.flatten.map { |i| i[:element] }.compact.uniq

    contents.reverse.each_with_index.map do |floor, i|
      num = contents.length - i
      element_contents = []

      elements.each do |element|
        {
          # type => abbreviation
          generator: 'G',
          microchip: 'M',
        }.each do |type, abbreviation|
          if floor.any? { |item| item[:type] == type && item[:element] == element }
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

  private

  def will_a_microchip_fry?(floor)
    microchips = floor.find_all { |item| item[:type] == 'microchip' }
    generators = floor.find_all { |item| item[:type] == 'generator' }

    powered_microchips = microchips.map { |m| m[:element] } & generators.map { |m| m[:generator] }

    # microchips don't interact unless one is powered by its RTG
    return false if powered_microchips.length == 0
  end
end

state = State.new(parse_input(ARGF))
puts state
