valid_count = 0

class VerticalReader
  def initialize(file)
    @contents = File.read(file)
  end

  def each_triangle(&block)
    triangles = [[], [], []]

    @contents.each_line do |line|
      triangle_one, triangle_two, triangle_three = line.strip.split
      triangles[0] << triangle_one
      triangles[1] << triangle_two
      triangles[2] << triangle_three

      if triangles[0].length == 3
        block.call(*triangles[0])
        block.call(*triangles[1])
        block.call(*triangles[2])

        triangles.map(&:clear)
      end
    end
  end
end

VerticalReader.new(ARGV[0])
  .each_triangle do |first, second, third|
    min, med, max = [first.to_i, second.to_i, third.to_i].sort
    valid_count += 1 if (min + med > max)
  end

puts valid_count
