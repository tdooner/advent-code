# input = $<.map(&:to_i)
input = $<.map { |l| l.strip.each_char.to_a }

class State
  def initialize(input)
    @state = input
  end

  def becomes_occupied?(i, j)
    [
      (@state.dig(i - 1, j - 1) if valid?(i - 1, j - 1)),
      (@state.dig(i - 1, j) if valid?(i - 1, j)),
      (@state.dig(i - 1, j + 1) if valid?(i - 1, j + 1)),
      (@state.dig(i, j - 1) if valid?(i, j - 1)),
      (@state.dig(i, j + 1) if valid?(i, j + 1)),
      (@state.dig(i + 1, j - 1) if valid?(i + 1, j - 1)),
      (@state.dig(i + 1, j) if valid?(i + 1, j)),
      (@state.dig(i + 1, j + 1) if valid?(i + 1, j + 1)),
    ].compact.none? { |adj| adj == '#' }
  end

  def becomes_unoccupied?(i, j)
    [
      (@state.dig(i - 1, j - 1) if valid?(i - 1, j - 1)),
      (@state.dig(i - 1, j) if valid?(i - 1, j)),
      (@state.dig(i - 1, j + 1) if valid?(i - 1, j + 1)),
      (@state.dig(i, j - 1) if valid?(i, j - 1)),
      (@state.dig(i, j + 1) if valid?(i, j + 1)),
      (@state.dig(i + 1, j - 1) if valid?(i + 1, j - 1)),
      (@state.dig(i + 1, j) if valid?(i + 1, j)),
      (@state.dig(i + 1, j + 1) if valid?(i + 1, j + 1)),
    ].compact.count { |adj| adj == '#' } >= 4
  end

  def becomes_occupied_part2?(i, j)
    [
      first_visible(i, j, -1, -1),
      first_visible(i, j, -1, 0),
      first_visible(i, j, -1, 1),
      first_visible(i, j, 0, -1),
      first_visible(i, j, 0, 1),
      first_visible(i, j, 1, -1),
      first_visible(i, j, 1, 0),
      first_visible(i, j, 1, 1),
    ].compact.none? { |adj| adj == '#' }
  end

  def becomes_unoccupied_part2?(i, j)
    [
      first_visible(i, j, -1, -1),
      first_visible(i, j, -1, 0),
      first_visible(i, j, -1, 1),
      first_visible(i, j, 0, -1),
      first_visible(i, j, 0, 1),
      first_visible(i, j, 1, -1),
      first_visible(i, j, 1, 0),
      first_visible(i, j, 1, 1),
    ].compact.count { |adj| adj == '#' } >= 5
  end

  def valid?(i, j)
    i >= 0 && i < @state.length &&
      j >= 0 && j < @state[0].length
  end

  def first_visible(i, j, di, dj)
    while valid?(i + di, j + dj)
      i += di
      j += dj
      return @state[i][j] if @state[i][j] != '.'
    end
  end

  def next_state
    next_state = []

    @state.each_with_index do |row, i|
      next_row = []

      row.each_with_index do |seat, j|
        case seat
        when 'L'
          if becomes_occupied_part2?(i, j)
            next_row << '#'
          else
            next_row << 'L'
          end
        when '#'
          if becomes_unoccupied_part2?(i, j)
            next_row << 'L'
          else
            next_row << '#'
          end
        when '.'
          next_row << '.'
        end
      end

      next_state << next_row
    end

    State.new(next_state)
  end

  def to_s
    @state.map(&:join).join("\n")
  end
end

def solve(input)
  current_state = State.new(input)
  next_state = nil
  loop do
    next_state = current_state.next_state
    puts '====================='
    puts next_state.to_s
    break if next_state.to_s == current_state.to_s
    current_state = next_state
  end

  next_state.to_s.each_char.count { |c| c == '#' }
end

puts solve(input)
