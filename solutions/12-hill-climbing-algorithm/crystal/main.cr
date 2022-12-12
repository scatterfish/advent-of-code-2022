require "priority-queue" # `shards install`

grid = File.read_lines("input.txt").map(&.chars)

HEIGHT_MAP = ('a'..'z').each_with_index.to_h
HEIGHT_MAP['S'] = HEIGHT_MAP['a']
HEIGHT_MAP['E'] = HEIGHT_MAP['z']

start_pos = {0, 0}
end_pos = {0, 0}
start_candidates = Set(Tuple(Int32, Int32)).new

(0...grid.size).each do |y|
	(0...grid[y].size).each do |x|
		
		case grid[y][x]
		when 'S'
			start_pos = {x, y}
			start_candidates << {x, y}
		when 'E'
			end_pos = {x, y}
		when 'a'
			start_candidates << {x, y}
		end
		
	end
end

def get_neighbors(grid, x, y)
	neighbors = Array(Tuple(Int32, Int32)).new
	neighbors << {x + 1, y} if x < grid[y].size - 1
	neighbors << {x - 1, y} if x > 0
	neighbors << {x, y + 1} if y < grid.size - 1
	neighbors << {x, y - 1} if y > 0
	return neighbors
end

def dijkstra(grid, start, targets, backwards = false)
	seen = Set(Tuple(Int32, Int32)).new
	queue = Priority::Queue(Tuple(Int32, Int32)).new
	
	queue.push(0, start)
	until queue.empty?
		
		item = queue.shift
		steps = item.priority
		coords = item.value
		
		next if seen.includes?(coords)
		return steps if targets.includes?(coords)
		
		seen << coords
		x, y = coords
		height = HEIGHT_MAP[grid[y][x]]
		
		neighbors = get_neighbors(grid, x, y)
		neighbors.each do |n_x, n_y|
			n_height = HEIGHT_MAP[grid[n_y][n_x]]
			delta = (n_height - height) * (backwards ? -1 : 1)
			queue.push(steps + 1, {n_x, n_y}) if delta <= 1
		end
		
	end
end

puts "Part 1 answer: #{dijkstra(grid, start_pos, Set{end_pos})}"
puts "Part 2 answer: #{dijkstra(grid, end_pos, start_candidates, true)}"
