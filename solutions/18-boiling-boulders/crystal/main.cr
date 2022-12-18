cubes = File.read_lines("input.txt").map(&.split(",").map(&.to_i)).to_set

# Thank goodness, something easier for once.

def each_neighbor(x, y, z)
	yield ([x - 1, y, z])
	yield ([x + 1, y, z])
	yield ([x, y - 1, z])
	yield ([x, y + 1, z])
	yield ([x, y, z - 1])
	yield ([x, y, z + 1])
end

def get_surface_area(cubes)
	surface_area = cubes.size * 6
	cubes.each do |cube|
		x, y, z = cube
		each_neighbor(x, y, z) do |neighbor|
			surface_area -= 1 if cubes.includes?(neighbor)
		end
	end
	return surface_area
end

max_dim = cubes.to_a.flatten.max
all_coords = (0..max_dim).to_a.repeated_permutations(3).to_set
empty_cubes = all_coords - cubes

air_pockets = Array(Set(Array(Int32))).new
until empty_cubes.empty?
	queue = Deque.new([empty_cubes.first])
	seen = Set(Array(Int32)).new
	
	until queue.empty?
		cube = queue.pop
		if empty_cubes.delete(cube) # check and delete at once
			seen << cube
			
			x, y, z = cube
			each_neighbor(x, y, z) do |neighbor|
				queue << neighbor
			end
		end
	end
	
	air_pockets << seen unless seen.includes?([0, 0, 0])
end

surface_area = get_surface_area(cubes)
empty_surface_area = air_pockets.sum { |pocket| get_surface_area(pocket) }

puts "Part 1 answer: #{surface_area}"
puts "Part 2 answer: #{surface_area - empty_surface_area}"
