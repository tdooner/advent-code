require_relative 'room.rb'

ARGF.each_line do |encrypted_room|
  r = Room.from_encrypted(encrypted_room.strip)
  puts [r.sector, r.decrypted_name].join("\t")
end
