require 'set'

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
    @history = Set.new
    @offset = { x: 0, y: 0 }
    @first_repeat = nil
  end

  # @param {String} move In format "L1" signifying "turn left and walk one
  #   block"
  def move(move)
    # first, turn in preparation for the move
    case move[0]
    when 'L'
      @direction = DIRECTIONS[@direction][:left]
    when 'R'
      @direction = DIRECTIONS[@direction][:right]
    end

    # then, walk that many blocks
    distance = move[1..-1].to_i
    distance.times do
      case @direction
      when NORTH
        @offset[:y] += 1
      when SOUTH
        @offset[:y] -= 1
      when EAST
        @offset[:x] += 1
      when WEST
        @offset[:x] -= 1
      end

      if !@first_repeat && has_visited?(*@offset.values_at(:x, :y))
        @first_repeat = @offset.dup
      end

      mark_visited(*@offset.values_at(:x, :y))
    end
  end

  def distance(x = @offset[:x], y = @offset[:y])
    x.abs + y.abs
  end

  def distance_of_first_duplicate_location
    return nil unless @first_repeat
    distance(*@first_repeat.values_at(:x, :y))
  end

  private

  def has_visited?(x, y)
    @history.include?([x, y])
  end

  def mark_visited(x, y)
    # save the (x, y) coordinate into an array of visited locations so we can
    # tell if we pass this coordinate again later
    @history << [x, y]
  end
end

def process_input(input_file)
  File.read(input_file).split(',').map(&:strip)
end

def run(moves)
  traveler = Traveler.new(Traveler::NORTH)

  moves.each do |move|
    traveler.move(move)
  end

  {
    part_one: traveler.distance,
    part_two: traveler.distance_of_first_duplicate_location,
  }
end

# first run it on the test data
raise unless 12 == run(%w[R5 L5 R5 R3])[:part_one]
raise unless 2 == run(%w[R2 R2 R2])[:part_one]
raise unless 4 == run(%w[R8 R4 R4 R8])[:part_two]

# then run it for realz
answers = run(process_input(File.expand_path('../input', __FILE__)))
puts answers.inspect
