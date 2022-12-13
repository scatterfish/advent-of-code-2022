pairs = File.read("input.txt").strip.split("\n\n").map { |pair| pair.lines(chomp: true) }

# lol

def compare(a, b)
	a = a.dup
	b = b.dup
	
	if a.is_a?(Integer) && b.is_a?(Integer)
		return a <=> b
	end
	
	if a.is_a?(Integer)
		return compare([a], b)
	end
	if b.is_a?(Integer)
		return compare(a, [b])
	end
	
	until a.empty? || b.empty?
		i = a.shift
		j = b.shift
		
		result = compare(i, j)
		next if result == 0
		return result
	end
	
	return -1 if a.empty? && b.any?
	return 1 if b.empty? && a.any?
	return 0
end

index_sum = 0
packets = []

pairs.each_with_index do |pair, i|
	pair.map! { |packet| eval(packet) } # don't `rm -rf` yourself pls
	packets += pair
	index_sum += i + 1 if compare(*pair) < 1
end

puts "Part 1 answer: #{index_sum}"

markers = [ [[2]], [[6]] ]
packets += markers
packets.sort! { |a, b| compare(a, b) }

marker_indices = markers.map { |marker| packets.index(marker) + 1 }
puts "Part 2 answer: #{marker_indices.reduce(:*)}"
