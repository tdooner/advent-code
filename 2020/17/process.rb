require 'pry'
input = $<.map { |l| l.strip.each_char.to_a }

class State
  def self.from_input(input, use_fourth_dimension: false)
    state = {}

    input.each_with_index.map do |row, y|
      row.each_with_index.map do |val, x|
        state[[x, y, 0, 0]] = val
      end
    end

    new(state, use_fourth_dimension: use_fourth_dimension)
  end

  def initialize(state_hash, use_fourth_dimension: false)
    @state = state_hash
    @use_fourth_dimension = use_fourth_dimension
    @extent = [
      @state.keys.map { |k| k[0] }.minmax,
      @state.keys.map { |k| k[1] }.minmax,
      @state.keys.map { |k| k[2] }.minmax,
      @state.keys.map { |k| k[3] }.minmax,
    ]
  end

  def next_state
    next_state = {}
    next_extent = @extent.map { |min, max| [min - 1, max + 1] }

    if !@use_fourth_dimension
      next_extent[-1] = [0, 0]
    end

    (next_extent[0][0]..next_extent[0][1]).each do |x|
      (next_extent[1][0]..next_extent[1][1]).each do |y|
        (next_extent[2][0]..next_extent[2][1]).each do |z|
          (next_extent[3][0]..next_extent[3][1]).each do |w|
            val = @state[[x, y, z, w]]
            active_neighbors =
              each_neighbor(x, y, z, w).count { |val| val == '#' }

            case val
            when '#'
              if active_neighbors == 2 || active_neighbors == 3
                next_state[[x, y, z, w]] = '#'
              else
                next_state[[x, y, z, w]] = '.'
              end
            when '.', nil
              if active_neighbors == 3
                next_state[[x, y, z, w]] = '#'
              else
                next_state[[x, y, z, w]] = '.'
              end
            end
          end
        end
      end
    end

    State.new(next_state, use_fourth_dimension: @use_fourth_dimension)
  end

  def each_neighbor(x, y, z, w)
    return to_enum(:each_neighbor, x, y, z, w) unless block_given?

    (-1..1).each do |d_x|
      (-1..1).each do |d_y|
        (-1..1).each do |d_z|
          (-1..1).each do |d_w|
            next if d_x == 0 && d_y == 0 && d_z == 0 && d_w == 0
            next if x + d_x < @extent[0][0] || x + d_x > @extent[0][1]
            next if y + d_y < @extent[1][0] || y + d_y > @extent[1][1]
            next if z + d_z < @extent[2][0] || z + d_z > @extent[2][1]
            next if w + d_w < @extent[3][0] || w + d_w > @extent[3][1]

            yield @state[[x + d_x, y + d_y, z + d_z, w + d_w]]
          end
        end
      end
    end
  end

  def to_s
    str = ""
    (@extent[3][0]..@extent[3][1]).each do |w|
      (@extent[2][0]..@extent[2][1]).each do |z|
        str << "z = #{z}, w = #{w}\n"
        (@extent[1][0]..@extent[1][1]).each do |y|
          (@extent[0][0]..@extent[0][1]).each do |x|
            str << @state[[x, y, z]]
          end
          str << "\n"
        end
        str << "\n"
      end
    end
    str
  end

  def num_active
    @state.count { |_k, v| v == '#' }
  end
end

def solve(input)
  state = State.from_input(input)
  state = state.next_state # cycle 1
  state = state.next_state # cycle 2
  state = state.next_state # cycle 3
  state = state.next_state # cycle 4
  state = state.next_state # cycle 5
  state = state.next_state # cycle 6
  state.num_active
end

def solve2(input)
  state = State.from_input(input, use_fourth_dimension: true)
  state = state.next_state # cycle 1
  state = state.next_state # cycle 2
  state = state.next_state # cycle 3
  state = state.next_state # cycle 4
  state = state.next_state # cycle 5
  state = state.next_state # cycle 6
  state.num_active
end

puts 'Part 1:'
puts solve(input)

puts 'Part 2 (this will take 20 sec):'
puts solve2(input)
