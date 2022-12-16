sensors, beacons =
	File.read_lines("input.txt")
		.map(&.split(":"))
		.transpose
		.map(&.map {|line|
			x, y = scan_numbers(line)
			{x, y}
		})

# Not a fan.

TARGET_Y = 2000000
SEARCH_SIZE = 4000000

def scan_numbers(line)
	line.scan(/-?[\d]+/).map(&.[0].to_i64)
end

def grid_dist(a, b)
	(a[0] - b[0]).abs + (a[1] - b[1]).abs
end

DIST_MAP = Hash(Tuple(Int64, Int64), Int64).new

sensors.zip(beacons) do |sensor, beacon|
	DIST_MAP[sensor] = grid_dist(sensor, beacon)
end

def merge_ranges(ranges)
	sorted = ranges.sort_by(&.begin)
	merged = [sorted.first]
	
	sorted.each do |range|
		if merged.last.end < range.begin
			merged << range
		elsif range.end > merged.last.end
			merged[-1] = (merged.last.begin..range.end)
		end
	end
	
	return merged
end

ranges = Array(Range(Int64, Int64)).new

sensors.each do |sensor|
	x, y = sensor
	delta = (y - TARGET_Y).abs
	radius = DIST_MAP[sensor] - delta
	next if radius < 1
	ranges << (x - radius..x + radius)
end

merged = merge_ranges(ranges)
range_sum = merged.sum(&.size)

occupied = (sensors | beacons).count {|_, y| y == TARGET_Y}

puts "Part 1 answer: #{range_sum - occupied}"

def sensor_radius(sensor, invert)
	radius = DIST_MAP[sensor] + 1
	x, y = sensor
	y *= invert
	return [x + y + radius, x + y - radius]
end

def out_of_range?(sensors, coord)
	coord  .all? { |pos| 0 <= pos <= SEARCH_SIZE } &&
	sensors.all? { |sensor| grid_dist(sensor, coord) > DIST_MAP[sensor] }
end

def intersect(a, b)
	x = (a + b) // 2
	y = a - x
	return {x, y}
end

sensors.each_combination(2, reuse: true) do |pair|
	[pair, pair.reverse].each do |(a, b)|
		radius_a = sensor_radius(a,  1)
		radius_b = sensor_radius(b, -1)
		
		radius_a.each do |pos_a|
			radius_b.each do |pos_b|
				x, y = intersect(pos_a, pos_b)
				
				if out_of_range?(sensors, {x, y})
					puts "Part 2 answer: #{x * 4000000 + y}"
					exit
				end
			end
		end
	end
end
