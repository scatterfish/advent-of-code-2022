numbers = File.read_lines("input.txt").map(&.to_i64)

def decrypt(numbers, iterations, decryption_key)
	decrypted = numbers.map_with_index { |num, i| {num * decryption_key, i} }
	
	iterations.times do
		numbers.each_with_index do |num, i|
			next if num == 0
			
			dec_i = decrypted.index { |_, dec_i| dec_i == i }.not_nil!
			val = decrypted.delete_at(dec_i)
			ins_i = (dec_i.to_i64 + val.first) % decrypted.size
			decrypted.insert(ins_i, val)
		end
	end
	
	zero_i = decrypted.index { |num, _| num == 0 }.not_nil!
	return [1000, 2000, 3000].sum { |offset|
		decrypted[(zero_i + offset) % decrypted.size].first
	}
end

puts "Part 1 answer: #{decrypt(numbers, 1, 1)}"
puts "Part 2 answer: #{decrypt(numbers, 10, 811589153)}"
