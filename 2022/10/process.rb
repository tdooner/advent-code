require 'bundler'; Bundler.require(:default)
def pbcopy(value); return if value.nil?; `/bin/bash -c 'echo -n "#{value}" | pbcopy'`; "#{value}    <- COPIED TO CLIPBOARD" end

def parse(input)
  input.split("\n").map { |l| cmd, num = l.split(' '); [cmd, num.to_i] }
end

def debug(&block)
  puts block.call if ENV['D'].present?
end

def part1(parsed)
  x = 1
  cycle = 0
  strength_values = []

  parsed.each do |cmd, num|
    cycle += 1

    if cmd == 'noop'
      strength_values << cycle * x if cycle % 40 == 20
    elsif cmd == 'addx'
      strength_values << cycle * x if cycle % 40 == 20
      cycle += 1
      strength_values << cycle * x if cycle % 40 == 20
      x += num
    end
  end

  strength_values.sum
end

def sprite(sprite_x, cycle)
  sprite_x <= (cycle - 1) % 40 && (cycle - 1) % 40 < sprite_x + 3 ? '#' : '.'
end

def part2(parsed)
  cycle = 0
  pixels = Array.new(40 * 6)
  sprite_x = 0

  parsed.each do |cmd, num|
    debug { "Sprite position: #{(0..40).map {|i| sprite_x <= i && i < sprite_x + 3 ? '#' : '.' }.join}\n\n" }

    cycle += 1
    debug { "Start cycle #{cycle}: begin executing #{cmd} #{num}" }

    debug { "During cycle #{cycle}: CRT draws pixel #{pixels[cycle - 1]} in pos #{cycle - 1}" }

    if cmd == 'noop'
      pixels[cycle - 1] = sprite(sprite_x, cycle)
    elsif cmd == 'addx'
      pixels[cycle - 1] = sprite(sprite_x, cycle)
      debug { "Current CRT row: #{pixels[(40 * (cycle / 40))..(40 * (1 + cycle / 40))].join}" }

      cycle += 1
      pixels[cycle - 1] = sprite(sprite_x, cycle)
      debug { "During cycle #{cycle}: CRT draws pixel #{pixels[cycle - 1]} in pos #{cycle - 1}" }

      sprite_x += num
      debug { "End of cycle #{cycle}: finish executing #{cmd} #{num} (register is now #{sprite_x})" }
    end

    debug { "Current CRT row: #{pixels[(40 * (cycle / 40))..(40 * (1 + cycle / 40))].join}" }
  end

  pixels.each_slice(40).map(&:join).join("\n")
end

parsed = parse(ARGF.read.chomp)

puts "Part 1:"
puts pbcopy(part1(parsed))

puts
puts "Part 2:"
puts pbcopy(part2(parsed))
