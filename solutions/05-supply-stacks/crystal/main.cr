drawing, instructions = File.read("input.txt").split("\n\n").map(&.lines)
drawing.pop # we don't care about the labels

towers = Array(Array(Char)).new

1.step(to: drawing.first.size, by: 4) do |col_i|
	tower = drawing.map(&.[col_i]).reject(' ')
	towers << tower.reverse
end

towers_2 = towers.clone

instructions.each do |instr|
	amount, from, to = instr.scan(/\d+/).map(&.[0].to_i)
	
	towers[to - 1]   += towers[from - 1]  .pop(amount).reverse
	towers_2[to - 1] += towers_2[from - 1].pop(amount)
end

def tops(towers)
	towers.map(&.last).join
end

puts "Part 1 answer: #{tops(towers)}"
puts "Part 2 answer: #{tops(towers_2)}"
