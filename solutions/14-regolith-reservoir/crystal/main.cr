scan = File.read_lines("input.txt").map(&.split(" -> ").map(&.split(",").map(&.to_i)))

world = Set(Tuple(Int32, Int32)).new

scan.each do |structure|
	structure.each_cons_pair do |*coords|
		
		[0, 1].each do |axis|
			min, max = coords.map(&.[axis]).minmax
			next if min == max
			(min..max).each do |pos|
				world <<
					(axis == 0 ? {pos, coords[1][1]} : {coords[0][0], pos})
			end
		end
		
	end
end

y_max = world.map(&.[1]).max

sand_path = Deque(Tuple(Int32, Int32)).new
sand_path << {500, 0}

def each_fall_pos(x, y)
	yield ({x, y + 1})
	yield ({x - 1, y + 1})
	yield ({x + 1, y + 1})
end

count = 0
first_below_count = 0

while true
	
	moved = false
	each_fall_pos(*sand_path.last) do |fall_pos|
		unless world.includes?(fall_pos)
			sand_path << fall_pos
			moved = true
			break
		end
	end
	
	last_y = sand_path.last[1]
	
	first_below_count = count if first_below_count == 0 && last_y > y_max
	world << sand_path.pop    if !moved || last_y == y_max + 2
	count += 1                unless moved
	
	if sand_path.empty?
		puts "Part 1 answer: #{first_below_count}"
		puts "Part 2 answer: #{count}"
		break
	end
	
end
