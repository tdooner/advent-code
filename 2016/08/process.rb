class ScreenProcessor
  INSTRUCTIONS = {
    # these capture groups match to the arguments passed to the inner methods
    /rect (\d+)x(\d+)/ =>
    ->(match) { [:rect, match[1].to_i, match[2].to_i] },
      /rotate column x=(\d+) by (\d+)/ =>
    ->(match) { [:rotate_column, match[1].to_i, match[2].to_i] },
      /rotate row y=(\d+) by (\d+)/ =>
    ->(match) { [:rotate_row, match[1].to_i, match[2].to_i] },
  }

  attr_accessor :board

  def initialize(width, height)
    @board = height.times.map { Array.new(width, false) }
  end

  def process_line(line)
    matching_instruction = INSTRUCTIONS.detect { |regex, _| line =~ regex }
    command = matching_instruction[1].call($~)

    case command.shift
    when :rect
      draw_rectangle(*command)
    when :rotate_row
      rotate_row(*command)
    when :rotate_column
      rotate_column(*command)
    end
  end

  def puts_screen
    @board.each do |row|
      row.each do |value|
        $stdout.write(value ? '#' : ' ')
      end

      $stdout.write "\n"
    end
  end

  private

  # turn on all pixels in [0, width] and [0, height]
  def draw_rectangle(width, height)
    height.times do |i|
      width.times do |j|
        @board[i][j] = true
      end
    end
  end

  # move pixels in row y right by num times
  def rotate_row(y, num)
    width = @board[y].length
    num = num % width
    row = @board[y].dup.concat(@board[y])
    @board[y] = row[(width - num)..-(num + 1)]
  end

  # move pixels in column x down num times
  def rotate_column(x, num)
    col = @board.map { |row| row[x] }
    height = col.length
    num = num % height
    rotated = col.dup.concat(col)[(height - num)..-(num + 1)]
    rotated.each_with_index do |new_value, y|
      @board[y][x] = new_value
    end
  end
end

width = ENV['WIDTH'] ? ENV['WIDTH'].to_i : 50
height = ENV['HEIGHT'] ? ENV['HEIGHT'].to_i : 6

processor = ScreenProcessor.new(width, height)

ARGF.each_line do |line|
  processor.process_line(line.strip)
end

processor.puts_screen
