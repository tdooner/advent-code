class Keypad
  attr_reader :code

  START_BUTTON = '5'

  def initialize(description)
    @description = description
    @code = ''

    # determine initial button placement (row/col) because it's hardcoded:
    # always start on "5"
    @description.each_with_index do |line, row|
      col = line.index(START_BUTTON)

      if col
        @button = { row: row, col: col }
        break
      end
    end
  end

  # @param {String} movements Series of movements from the previous button
  def process_movements(movements)
    movements.each_char do |move|
      next_button = next_coordinates(move)

      if valid_location?(next_button)
        @button = next_button
      end
    end

    @code += at(@button[:row], @button[:col])
  end

  private

  def at(row, col)
    return nil if row < 0 # overflowed above the board
    return nil if row >= @description.length # overflowed below the board
    return nil if col < 0 # overflowed left of board
    return nil if col >= @description[row].length # overflowed right of board

    value = @description[row][col]

    return nil if value.nil? # overflowed left of board
    return nil if value == ' ' # overflowed left of board

    value
  end

  def valid_location?(next_button)
    !at(next_button[:row], next_button[:col]).nil?
  end

  def next_coordinates(direction)
    @button.dup.tap do |next_button|
      case direction
      when 'U'
        next_button[:row] -= 1
      when 'D'
        next_button[:row] += 1
      when 'L'
        next_button[:col] -= 1
      when 'R'
        next_button[:col] += 1
      end
    end
  end
end

k = Keypad.new(File.read(ARGV.shift).each_line.map(&:rstrip))

File.read(ARGV.shift).each_line.map(&:strip).each do |line|
  k.process_movements(line)
end

puts k.code
