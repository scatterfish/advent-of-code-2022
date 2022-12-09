steps = File.read_lines("input.txt").map(&.split)

class Point
	property x : Int32 = 0
	property y : Int32 = 0
	
	def to_tuple
		{@x, @y}
	end
end

rope = Array(Point).new(10) { Point.new }

visited = rope.map { |pos| Set{pos.to_tuple} }

steps.each do |(dir, dist)|
	
	dist.to_i.times do
		
		case dir
		when "R"
			rope.first.x += 1
		when "L"
			rope.first.x -= 1
		when "D"
			rope.first.y += 1
		when "U"
			rope.first.y -= 1
		end
		
		rope.each_cons(2).with_index do |(prev, curr), i|
			delta_x = prev.x - curr.x
			delta_y = prev.y - curr.y
			
			if delta_x.abs >= 2 || delta_y.abs >= 2
				curr.x += delta_x.sign
				curr.y += delta_y.sign
			end
			visited[i + 1] << curr.to_tuple
		end
		
	end
	
end

puts "Part 1 answer: #{visited[1].size}"
puts "Part 2 answer: #{visited.last.size}"
