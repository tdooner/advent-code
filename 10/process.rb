class BotOutput < Struct.new(:type, :value); end
class BotRunner
  VALUE_REGEX = /value (?<value>\d+) goes to bot (?<bot>\d+)/
  BOT_REGEX = %r{
    bot\s(?<bot>\d+)\sgives\s
    low\sto\s(?<low_output_type>output|bot)\s(?<low_output>\d+)\sand\s
    high\sto\s(?<high_output_type>output|bot)\s(?<high_output>\d+)
  }x

  def initialize
    @initial_values = {}
    @bot_specifications = {}
    @watch = nil
  end

  def add_watch(value1, value2, &block)
    @watch = [value1, value2, block]
  end

  def add_instruction(instruction)
    case instruction
    when VALUE_REGEX
      @initial_values[$~['value'].to_i] = $~['bot'].to_i
    when BOT_REGEX
      @bot_specifications[$~['bot'].to_i] = {
        low: BotOutput.new($~['low_output_type'], $~['low_output'].to_i),
        high: BotOutput.new($~['high_output_type'], $~['high_output'].to_i),
      }
    end
  end

  # the exclamation mark stands for excitement! not danger!
  def simulate!
    bots = @bot_specifications.each_with_object({}) do |(bot, spec), hash|
      initial_values = @initial_values.find_all { |k, v| v == bot }
      hash[bot] = Bot.new(initial_values.map(&:first), spec[:low], spec[:high])
    end

    loop do
      steps = bots.map { |id, bot| [id, bot.run_step] }.find_all(&:last)
      return if steps.empty?
      steps.each do |id, commands|
        commands.each do |command|
          case command[0]
          when :compared
            if @watch && command[1] == @watch[0] && command[2] == @watch[1]
              @watch[2].call(id)
            end
          when :give
            if command[1] == 'bot'
              recipient_bot = command[2]
              recipient_value = command[3]
              bots[recipient_bot].receive_value(recipient_value)
            elsif command[1] == 'output'
              recipient_output = command[2]
              recipient_value = command[3]
              puts "output #{recipient_output} gets value #{recipient_value}"
            end
          end
        end
      end
    end
  end
end

class Bot
  def initialize(starting_values, low_output, high_output)
    @values = starting_values
    @watch = nil
    @low_output = low_output
    @high_output = high_output
  end

  def receive_value(value)
    @values << value
  end
  
  def run_step
    # robot does nothing unless it has two cards
    return unless @values.length == 2

    @values.sort!

    [
      [:compared, @values[0], @values[1]],
      [:give, @low_output.type, @low_output.value, @values.shift],
      [:give, @high_output.type, @high_output.value, @values.shift],
    ]
  end
end

runner = BotRunner.new

ARGF.each_line do |line|
  runner.add_instruction(line.strip)
end

if ENV['WATCH'] == '1'
  runner.add_watch(2, 3) do |bot|
    puts "watch triggered: #{bot} compared 2 and 3"
  end
elsif ENV['WATCH'] == '2'
  runner.add_watch(17, 61) do |bot|
    puts "watch triggered: #{bot} compared 17 and 67"
  end
end

runner.simulate!
