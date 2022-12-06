data = File.read("input.txt").strip.chars

def first_uniq_seq(data, len)
	data.each_cons(len).with_index do |seq, i|
		return i + len if seq.uniq.size == len
	end
end

puts "Part 1 answer: #{first_uniq_seq(data, 4)}"
puts "Part 2 answer: #{first_uniq_seq(data, 14)}"
