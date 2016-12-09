class Traveler
  NORTH = :north
  SOUTH = :south
  EAST = :east
  WEST = :west
  DIRECTIONS = {
    NORTH => { right: EAST, left: WEST },
    SOUTH => { right: WEST, left: EAST },
    WEST => { right: NORTH, left: SOUTH },
    EAST => { right: SOUTH, left: NORTH },
  }

  def initialize(direction)
    @direction = direction
    @offset = { x: 0, y: 0 }
  end

  # @param {String} move In format "L1" signifying "turn left and walk one
  #   block"
  def move(move)
    # first, turn
    case move[0]
    when 'L'
      @direction = DIRECTIONS[@direction][:left]
    when 'R'
      @direction = DIRECTIONS[@direction][:right]
    end

    # then, walk that many blocks
    distance = move[1..-1].to_i
    case @direction
    when NORTH
      @offset[:y] += distance
    when SOUTH
      @offset[:y] -= distance
    when EAST
      @offset[:x] += distance
    when WEST
      @offset[:x] -= distance
    end
  end

  def distance
    @offset[:x].abs + @offset[:y].abs
  end
end

traveler = Traveler.new(Traveler::NORTH)

input_file = File.expand_path('../input', __FILE__)
File.read(input_file).split(',').map(&:strip).each do |move|
  traveler.move(move)
end

puts traveler.distance
