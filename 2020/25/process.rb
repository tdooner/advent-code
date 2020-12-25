require 'pry'
MODULUS = 20201227
card_public_key, door_public_key = $<.read.split("\n").map(&:to_i)

def bruteforce_loop_size(public_key, subject_number)
  times = 0
  current = 1
  loop do
    times += 1
    current = (current * subject_number) % MODULUS
    break if current == public_key
  end

  times
end

def transform(loop_size, subject_number)
  current = subject_number
  (loop_size - 1).times do
    current = current * subject_number % MODULUS
  end
  current
end

def solve(card_public_key, door_public_key)
  card_loop_size = bruteforce_loop_size(card_public_key, 7)
  door_loop_size = bruteforce_loop_size(door_public_key, 7)

  encryption_key = transform(card_loop_size, door_public_key)
  encryption_key_2 = transform(door_loop_size, card_public_key)
  raise unless encryption_key == encryption_key_2

  puts 'Part 1:'
  puts encryption_key
end

solve(card_public_key, door_public_key)
