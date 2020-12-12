input = $<.map(&:strip).map { |l| [l[0], l[1..-1].to_i] }

def solve(input)
  direction = 90
  x = 0
  y = 0
  input.each do |(act, dist)|
    case act
    when 'N'
      y -= dist
    when 'S'
      y += dist
    when 'E'
      x += dist
    when 'W'
      x -= dist
    when 'L'
      puts ['turning left', dist, direction].inspect
      direction -= dist
      direction = direction % 360
      puts direction
    when 'R'
      direction += dist
      puts ['turning right', dist, direction].inspect
      direction = direction % 360
      puts direction
    when 'F'
      case direction
      when 0
        y -= dist
      when 90
        x += dist
      when 180
        y += dist
      when 270
        x -= dist
      end
    end
  end

  puts [x, y].inspect

  x.abs + y.abs
end

def solve2(input)
  direction = 90
  x = 0
  y = 0
  waypoint_x = 10
  waypoint_y = 1

  input.each do |(act, dist)|
    puts [act, dist, x, y, waypoint_x, waypoint_y].inspect
    case act
    when 'N'
      waypoint_y += dist
    when 'S'
      waypoint_y -= dist
    when 'E'
      waypoint_x += dist
    when 'W'
      waypoint_x -= dist
    when 'L'
      case dist % 360
      when 90
        new_x = -1 * waypoint_y
        new_y = waypoint_x
      when 180
        new_x = -1 * waypoint_x
        new_y = -1 * waypoint_y
      when 270
        new_x = waypoint_y
        new_y = -1 * waypoint_x
      end
      waypoint_x = new_x
      waypoint_y = new_y
    when 'R'
      case dist % 360
      when 90
        new_x = waypoint_y
        new_y = -1 * waypoint_x
      when 180
        new_x = -1 * waypoint_x
        new_y = -1 * waypoint_y
      when 270
        new_x = -1 * waypoint_y
        new_y = waypoint_x
      end
      waypoint_x = new_x
      waypoint_y = new_y
    when 'F'
      x += waypoint_x * dist
      y += waypoint_y * dist
    end
  end

  puts [x, y].inspect

  x.abs + y.abs
end
puts solve2(input)
