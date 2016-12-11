class IPv7Address
  def self.from_string(str)
    negate = false
    supports_tls = false

    str.scan(/[a-z]+|\[|\]/).each do |part|
      if part == '[' || part == ']'
        negate = part == '['
        next
      end

      part.each_char.each_cons(4) do |a, b, c, d|
        next unless a == d && b == c && a != b

        supports_tls = true unless negate

        # an abba in a negative space overrides anything else
        return new(false) if negate
      end
    end

    new(supports_tls)
  end

  def initialize(supports_tls)
    @supports_tls = supports_tls
  end

  def supports_tls?
    @supports_tls
  end
end

valid = 0
ARGF.each_line do |address|
  a = IPv7Address.from_string(address)

  valid += 1 if a.supports_tls?
end

puts valid
