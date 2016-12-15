require 'json'

MICROCHIP = /(?<element>\w+)-compatible microchip/
GENERATOR = /(?<element>\w+) generator/

def parse_input(file)
  floor_contents = [[{ type: :elevator }]]

  ARGF.each_line.each_with_index do |line, floor|
    floor_contents[floor] ||= []

    line.scan(MICROCHIP) do |microchip|
      floor_contents[floor] << { type: :microchip, element: microchip.first }
    end

    line.scan(GENERATOR) do |generator|
      floor_contents[floor] << { type: :generator, element: generator.first }
    end
  end

  floor_contents
end

if __FILE__ == $0
  puts parse_input(ARGV).inspect
end
