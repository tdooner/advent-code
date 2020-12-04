require 'pry'
EXPECTED = {
  'byr' => { min: 1920, max: 2002 },
  'iyr' => { min: 2010, max: 2020 },
  'eyr' => { min: 2020, max: 2030 },
  'hgt' => { height: { cm: (150..193), in: (59..76) } },
  'hcl' => { regex: /^#[0-9a-f]{6}$/i },
  'ecl' => { regex: /^(amb|blu|brn|gry|grn|hzl|oth)$/ },
  'pid' => { regex: /^[0-9]{9}$/ },
  'cid' => {}
}

def part1(input)
  (EXPECTED.keys - ['cid']).all? { |field| input.split(/\s/).any? { |passport_field| passport_field.start_with?(field + ':') } }
end

def part2(input)
  fields = input.split(/\s/)

  puts fields.inspect
  part1(input) && fields.all? do |field|
    key, value = field.split(':')
    validators = EXPECTED[key]

    valid = validators.find_all do |validator_type, validator_value|
      case validator_type
      when :min
        value.to_i >= validator_value
      when :max
        value.to_i <= validator_value
      when :height
        if value =~ /(\d+)cm/
          validator_value[:cm].include?($~[0].to_i)
        elsif value =~ /(\d+)in/
          validator_value[:in].include?($~[0].to_i)
        end
      when :regex
        value.match?(validator_value)
      end
    end

    valid.length == validators.length
  end
end

$num_valid = 0
passport = ''
passport_i = 1
File.read(ARGV[0] == '--test' ? 'test-input-2' : 'input').each_line do |line|
  if line.strip == ''
    puts "passport #{passport_i}: #{part2(passport)}"
    $num_valid += 1 if part2(passport)
    passport = ''
    passport_i += 1
  else
    passport << line
  end
end
$num_valid += 1 if part2(passport)
puts "passport #{passport_i}: #{part2(passport)}"

puts 'Part 1:'

puts 'Part 2:'
puts $num_valid
