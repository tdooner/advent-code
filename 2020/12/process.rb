require 'matrix'

input = $<.map(&:strip).map { |l| [l[0], l[1..-1].to_i] }

VECTORS = {
  'N' => [0, 1],
  'S' => [0, -1],
  'E' => [1, 0],
  'W' => [-1, 0],
}

class Ship
  def initialize
    @direction = 0    # East, just like in math!
    @x = 0
    @y = 0
  end

  # vector is an [x, y] vector
  def move(vector, distance)
    @x += vector[0] * distance
    @y += vector[1] * distance
  end

  def rotate(degrees)
    @direction += degrees
  end

  def move_forward(distance)
    @x += Math.cos(@direction * Math::PI / 180).round * distance
    @y += Math.sin(@direction * Math::PI / 180).round * distance
  end

  def manhattan_distance
    @x.abs + @y.abs
  end

  def to_s
    [@x, @y, @direction].inspect
  end
end

def rotation_matrix(degrees, direction)
  theta = (degrees * Math::PI / 180)

  case direction
  when 'L'
    Matrix[[Math.cos(theta), Math.sin(theta)], [-1 * Math.sin(theta), Math.cos(theta)]]
  when 'R'
    Matrix[[Math.cos(theta), -1 * Math.sin(theta)], [Math.sin(theta), Math.cos(theta)]]
  end
end

def solve(input)
  ship = Ship.new

  input.each do |(action, dist)|
    case action
    when 'N', 'S', 'E', 'W'
      ship.move(VECTORS[action], dist)
    when 'L'
      ship.rotate(dist)
    when 'R'
      ship.rotate(-1 * dist)
    when 'F'
      ship.move_forward(dist)
    end
  end

  ship.manhattan_distance
end

def solve2(input)
  ship = Ship.new
  waypoint = [10, 1]

  input.each do |(action, dist)|
    case action
    when 'N', 'S', 'E', 'W'
      translation_matrix = Matrix[[dist]] * Matrix[VECTORS[action]]
      waypoint = (Matrix[waypoint] + translation_matrix).to_a.first
    when 'L', 'R'
      waypoint = (Matrix[waypoint] * rotation_matrix(dist, action)).to_a.first.map(&:round)
    when 'F'
      ship.move(waypoint, dist)
    end
  end

  ship.manhattan_distance
end

puts 'Part 1:'
puts solve(input)

puts 'Part 2:'
puts solve2(input)
