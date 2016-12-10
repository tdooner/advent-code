require 'openssl'

class Bruteforcer
  def each_char(prefix)
    return to_enum(:each_char, prefix) unless block_given?

    i = 0

    while true
      hash = OpenSSL::Digest::MD5.new.digest("#{prefix}#{i}")
      i += 1
      next unless hash.start_with?("\x00\x00")
      hex = hash.unpack('H*')[0]
      next unless hex.start_with?('00000')
      yield hex[5]
    end
  end
end

prefix = ARGV.shift
puts Bruteforcer.new.each_char(prefix).first(8).join
