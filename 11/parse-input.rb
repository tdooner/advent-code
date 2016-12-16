require 'json'

MICROCHIP = /(?<element>\w+)-compatible microchip/
GENERATOR = /(?<element>\w+) generator/

class Item < Struct.new(:type, :element)
  def <=>(other)
    [other.type, other.element] <=> [self.type, self.element]
  end

  def generator?
    type == :generator
  end

  def microchip?
    type == :microchip
  end

  def elevator?
    type == :elevator
  end
end

def parse_input(file)
  floor_contents = [[Item.new(:elevator)]]

  ARGF.each_line.each_with_index do |line, floor|
    floor_contents[floor] ||= []

    line.scan(MICROCHIP) do |microchip|
      floor_contents[floor] << Item.new(:microchip, microchip.first)
    end

    line.scan(GENERATOR) do |generator|
      floor_contents[floor] << Item.new(:generator, generator.first)
    end
  end

  floor_contents
end

if __FILE__ == $0
  puts parse_input(ARGV).inspect
end
