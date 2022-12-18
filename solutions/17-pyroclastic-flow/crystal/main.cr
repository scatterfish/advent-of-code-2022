pattern = File.read("input.txt").strip.chars

SHAPES = [ # Behold, art.
	[
		{0, 0}, {1, 0}, {2, 0}, {3, 0}
	],
	[
		        {1, 2},
		{0, 1}, {1, 1}, {2, 1},
		        {1, 0},
	],
	[
		                {2, 2},
		                {2, 1},
		{0, 0}, {1, 0}, {2, 0},
	],
	[
		{0, 3},
		{0, 2},
		{0, 1},
		{0, 0},
	],
	[
		{0, 1}, {1, 1},
		{0, 0}, {1, 0},
	],
]

LIMIT = 30_000

alias Point = Tuple(Int32, Int32)
alias CycleKey = Tuple(Int32, Int32, Set(Point))

def shape_to_points(shape, x, y)
	shape.map { |(s_x, s_y)| {x + s_x, y + s_y} }
end

def find_cycle_params(pattern)
	world = Set(Point).new
	
	rocks = 0
	max_y = 0
	
	shape_i = 0
	dir_i = 0
	
	cycle_map = Hash(CycleKey, Int32).new
	height_map = Hash(Int32, Int32).new
	
	until rocks == LIMIT
		top_20_rows = Set(Point).new
		world.each do |point|
			w_x, w_y = point
			delta = max_y - w_y
			top_20_rows << {w_x, max_y - w_y} if delta.abs <= 20
			world.delete(point) if w_y < max_y - 50 # cull for performance
		end
		
		cycle_key = {shape_i, dir_i, top_20_rows}
		cycle_start_rocks = cycle_map[cycle_key]?
		return {cycle_start_rocks, rocks, height_map} if cycle_start_rocks
		
		shape = SHAPES[shape_i]
		shape_i = (shape_i + 1) % SHAPES.size
		
		x = 2
		y = world.empty? ? 3 : max_y + 4
		fall_turn = false
		
		loop do
			prev_x = x
			prev_y = y
			
			if fall_turn
				y -= 1
			else
				dir = pattern[dir_i]
				dir_i = (dir_i + 1) % pattern.size
				x += dir == '>' ? 1 : -1
			end
			
			points = shape_to_points(shape, x, y)
			
			in_bounds = points.all? { |(p_x, p_y)| 0 <= p_x < 7 && p_y >= 0 }
			colliding = points.any? { |point| world.includes?(point) }
			
			if colliding || !in_bounds
				x = prev_x
				y = prev_y
				
				if fall_turn && (colliding || y == 0)
					points = shape_to_points(shape, x, y)
					world.concat(points)
					max_y = world.max_of(&.[1])
					
					cycle_map[cycle_key] = rocks
					height_map[rocks] = max_y
					break
				end
			end
			
			fall_turn = !fall_turn
		end
		
		rocks += 1
	end
end

def extrapolate_cycle(target_rocks, cycle_start, cycle_end, height_map)
	start_height = height_map[cycle_start].to_u64
	end_height   = height_map[cycle_end - 1]
	cycle_delta  = end_height - start_height
	
	cycle_length = cycle_end - cycle_start
	cycle_count, cycle_remainder =
		(target_rocks - cycle_start).divmod(cycle_length)
	
	remainder_end = cycle_start + cycle_remainder
	remainder_height = height_map[remainder_end - 1]
	remainder_delta  = remainder_height - start_height
	
	return start_height + (cycle_count * cycle_delta) + remainder_delta + 1
end

cycle_params = find_cycle_params(pattern).not_nil!

puts "Part 1 answer: #{extrapolate_cycle(2022, *cycle_params)}"
puts "Part 2 answer: #{extrapolate_cycle(1_000_000_000_000, *cycle_params)}"
