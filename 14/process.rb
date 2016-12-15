require 'openssl'

def hash_triple(str)
  str.each_char.each_cons(3).detect { |a, b, c| a == b && b == c }&.first
end

def hash_five_sequences(str)
  str.each_char.each_cons(5)
    .find_all { |a, b, c, d, e| a == b && b == c && c == d && d == e }
    .map(&:first)
end

class ThousandHashFutureReader
  def initialize(salt)
    @salt = salt
    @buffer = Array.new(1000, '')
    @five_cache = Array.new(1000, false)
    @i = 0
  end

  def has_five_sequence_in_next_thousand_hashes?(char)
    idx = @i % @buffer.length

    return true if @five_cache[idx] == char

    @buffer.each_with_index do |hex, j|
      next if j == idx

      if fives = hash_five_sequences(hex)
        @five_cache[idx] = fives.first
      end

      return true if fives.include?(char)
    end

    false
  end

  def each_hash(&block)
    loop do
      hash = OpenSSL::Digest::MD5.new.digest(@salt + @i.to_s)
      hex = hash.unpack('H*')[0]

      idx = @i % @buffer.length
      if @i > @buffer.length
        yield [@buffer[idx], @i - @buffer.length]
      end

      @buffer[idx] = hex
      @five_cache[idx] = false

      @i += 1
    end
  end
end

keys = 0
reader = ThousandHashFutureReader.new(ARGV.shift)
reader.each_hash do |hash, i|
  triple = hash_triple(hash)

  if triple && reader.has_five_sequence_in_next_thousand_hashes?(triple)
    puts [keys + 1, i, hash].inspect
    keys += 1
    break if keys == 64
  end
end
