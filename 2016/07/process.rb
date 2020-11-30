require 'set'

class IPv7Address
  def self.from_string(str)
    negate = false
    supports_tls = false
    negates_tls = false
    abas = Set.new

    # during the first scan, determine if the IP supports "TLS" while also
    # keeping track of all "ABA"s
    str.scan(/[a-z]+|\[|\]/).each do |part|
      if part == '[' || part == ']'
        negate = part == '['
        next
      end

      if !negate
        abas |= part.each_char.each_cons(3).map(&:join)
      end

      part.each_char.each_cons(4) do |a, b, c, d|
        next unless a == d && b == c && a != b

        supports_tls = true unless negate
        negates_tls = true if negate
      end
    end

    # then, parse the string again to determine if the IP supports "SSL" if we
    # are in a negation block and a 3-letter sequence matches a previous "ABA"
    negate = false
    supports_ssl = false
    str.scan(/[a-z]+|\[|\]/).each do |part|
      if part == '[' || part == ']'
        negate = part == '['
        next
      end

      if negate
        babs = part.each_char.each_cons(3)
          .find_all { |a, b, c| a == c && b != c }
          .map { |a, b, _| "#{b}#{a}#{b}" }
        supports_ssl |= !(abas & babs).empty?
      end
    end

    new(supports_tls && !negates_tls, supports_ssl)
  end

  def initialize(supports_tls, supports_ssl)
    @supports_tls = supports_tls
    @supports_ssl = supports_ssl
  end

  def supports_tls?
    @supports_tls
  end

  def supports_ssl?
    @supports_ssl
  end
end

valid_tls = 0
valid_ssl = 0

ARGF.each_line do |address|
  a = IPv7Address.from_string(address)

  valid_tls += 1 if a.supports_tls?
  valid_ssl += 1 if a.supports_ssl?
end

puts "Num supporting TLS (part one): #{valid_tls}"
puts "Num supporting SSL (part two): #{valid_ssl}"
