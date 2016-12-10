class Room
  ENCRYPTED_REGEX = /(?<name>([a-z]+-)+)(?<sector>[0-9]+)\[(?<checksum>[a-z]+)\]/

  attr_reader :sector

  def self.from_encrypted(str)
    match = str.match(ENCRYPTED_REGEX)
    new(match['name'][0..-2], match['sector'], match['checksum'])
  end

  def initialize(name, sector, checksum)
    @name = name
    @sector = sector.to_i
    @checksum = checksum
  end

  def valid?
    @checksum == correct_checksum
  end

  def decrypted_name
    @name.gsub('-', ' ').each_byte.map do |byte|
      next ' ' if byte == 32 # ascii 32 is ' '

      (97 + (((byte - 97) + @sector) % 26)).chr
    end.join
  end

  private

  def correct_checksum
    frequencies = @name.gsub('-', '').each_char.each_with_object(Hash.new(0)) do |char, hash|
      hash[char] += 1
    end

    frequencies
      .sort_by { |k, v| -v }
      .chunk_while { |first, second| first[1] == second[1] }
      .each_with_object('') do |chunk, str|
        str << chunk.map(&:first).sort.first(5 - str.length).join
      end
  end
end
