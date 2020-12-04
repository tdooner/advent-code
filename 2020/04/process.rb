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
  provided_fields = input.split(/\s/).map { |f| f.split(':')[0] }
  expected_fields = EXPECTED.keys - ['cid']

  (provided_fields & expected_fields).length == expected_fields.length
end

def part2(input)
  fields = input.split(/\s/)

  return false unless part1(input)

  fields.all? do |field|
    key, value = field.split(':')
    validators = EXPECTED[key]

    validators.all? do |validator_type, validator_value|
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
  end
end

passports = File.read(ARGV[0]).each_line.slice_when { |line| line == "\n" }.map(&:join)

puts 'Part 1:'
puts passports.count { |p| part1(p) }

puts 'Part 2:'
puts passports.count { |p| part2(p) }
