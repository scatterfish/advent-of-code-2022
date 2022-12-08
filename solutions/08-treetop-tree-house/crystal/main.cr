grid = File.read_lines("input.txt").map(&.chars.map(&.to_i))

visible_count = 0
scenic_scores = Array(Int32).new

def scan_score(scan, max_height)
	score = 0
	scan.each do |h|
		score += 1
		break if h >= max_height
	end
	return score
end

(0...grid.size).each do |y|
	(0...grid[y].size).each do |x|
		height = grid[y][x]
		
		scan_left  = (0...x)               .map { |scan_x| grid[y][scan_x] }
		scan_right = (x + 1...grid[y].size).map { |scan_x| grid[y][scan_x] }
		
		scan_up   = (0...y)            .map { |scan_y| grid[scan_y][x] }
		scan_down = (y + 1...grid.size).map { |scan_y| grid[scan_y][x] }
		
		scans = [scan_left.reverse, scan_down, scan_up.reverse, scan_right]
		
		visible_count += 1 if scans.any?(&.all? { |h| h < height })
		
		scenic_scores << scans
			.map { |scan| scan_score(scan, height) }
			.product
	end
end

puts "Part 1 answer: #{visible_count}"
puts "Part 2 answer: #{scenic_scores.max}"
