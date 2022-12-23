grid = File.read_lines("input.txt").map(&.chars)

alias Point = Tuple(Int32, Int32)

cells = Set(Point).new

(0...grid.size).each do |y|
	(0...grid[y].size).each do |x|
		if grid[y][x] == '#'
			cells << {x, y}
		end
	end
end

directions = [
	{[{-1, -1}, { 0, -1}, { 1, -1}], { 0, -1}}, # NW, N, NE -> N
	{[{-1,  1}, { 0,  1}, { 1,  1}], { 0,  1}}, # SW, S, SE -> S
	{[{-1, -1}, {-1,  0}, {-1,  1}], {-1,  0}}, # NW, W, SW -> W
	{[{ 1, -1}, { 1,  0}, { 1,  1}], { 1,  0}}, # NE, E, SE -> E
]

move_map = Hash(Point, Point).new

(0..).each do |i|
	move_map.clear
	
	cells.each do |(x, y)|
		moves = directions.compact_map { |(deltas, move)|
			neighbors = deltas.map { |(d_x, d_y)| {x + d_x, y + d_y} }
			move if neighbors.none? { |neighbor| cells.includes?(neighbor) }
		}
		next if moves.empty? || moves.size == 4
		m_d_x, m_d_y = moves.first
		move_map[{x, y}] = {x + m_d_x, y + m_d_y}
	end
	
	if i == 10
		x_min, x_max = cells.map(&.[0]).minmax
		y_min, y_max = cells.map(&.[1]).minmax
		
		x_size = x_max - x_min + 1
		y_size = y_max - y_min + 1
		
		puts "Part 1 answer: #{x_size * y_size - cells.size}"
	end
	
	if move_map.empty?
		puts "Part 2 answer: #{i + 1}"
		break
	end
	
	move_tallies = move_map.values.tally
	move_map.each do |cell, move|
		if move_tallies[move] == 1
			cells.delete(cell)
			cells << move
		end
	end
	
	directions.rotate!
end
