class Keypad
  attr_reader :code

  def initialize
    @button = 5
    @code = ''
  end

  # @param {String} movements Series of movements from the previous button
  def process_movements(movements)
    movements.each_char do |char|
      case char
      when 'U'
        @button -= 3 if @button > 3
      when 'D'
        @button += 3 if @button <= 6
      when 'L'
        @button -= 1 if @button % 3 != 1
      when 'R'
        @button += 1 if @button % 3 != 0
      end
    end

    @code += @button.to_s
  end
end

k = Keypad.new

ARGF.each_line.map(&:strip).each do |line|
  k.process_movements(line)
end

puts k.code
