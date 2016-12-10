require_relative 'room.rb'
sector_total = 0

ARGF.each_line do |encrypted_room|
  room = Room.from_encrypted(encrypted_room.strip)
  sector_total += room.sector if room.valid?
end

puts sector_total
