require 'openssl'

class Bruteforcer
  def password(prefix, length)
    str = ' ' * length
    i = 0

    while true
      hash = OpenSSL::Digest::MD5.new.digest("#{prefix}#{i}")
      i += 1
      next unless hash.start_with?("\x00\x00")
      hex = hash.unpack('H*')[0]
      next unless hex.start_with?('00000')
      pos = hex[5].to_i
      next unless pos > 0 && pos < length || (pos == 0 && hex[5] == '0')
      str[pos] = hex[6] if str[pos] == ' '
      break if !str.include?(' ')
    end

    str
  end
end

prefix = ARGV.shift
puts Bruteforcer.new.password(prefix, 8)
