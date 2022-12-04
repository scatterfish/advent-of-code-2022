ranges = File.read_lines("input.txt").map(&.split(",").map(&.split("-").map(&.to_i)))

macro cover?(method)
	[pair, pair.reverse].any? { |(a, b)| a.{{method}} { |i| b.covers?(i) } }
end

contain = 0
overlap = 0

ranges.each do |pair|
	pair = pair.map { |(s, e)| s..e }
	contain += 1 if cover?(all?)
	overlap += 1 if cover?(any?)
end

puts "Part 1 answer: #{contain}"
puts "Part 2 answer: #{overlap}"
