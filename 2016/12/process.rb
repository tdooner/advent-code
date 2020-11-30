class AssembunnyProcessor
  attr_reader :registers

  def initialize(instructions)
    @index = 0
    @instructions = instructions
    @registers = { a: 0, b: 0, c: ENV['C'].to_i, d: 0 }
  end

  def process!
    while @index < @instructions.length
      send(@instructions[@index][0], *@instructions[@index][1..-1])
    end
  end

  def cpy(x, y)
    if @registers.include?(x.to_sym)
      val = @registers[x.to_sym]
    else
      val = x.to_i
    end
    @registers[y.to_sym] = val
    @index += 1
  end

  def inc(x)
    @registers[x.to_sym] += 1
    @index += 1
  end

  def dec(x)
    @registers[x.to_sym] -= 1
    @index += 1
  end

  def jnz(x, y)
    if @registers[x.to_sym] != 0
      @index += y.to_i
    else
      @index += 1
    end
  end
end

processor = AssembunnyProcessor.new(ARGF.each_line.map(&:strip).map(&:split))
processor.process!
puts processor.registers[:a]
