rucksacks = File.read_lines("input.txt").map(&.chars)

PRIORITY_MAP = (('a'..'z').to_a + ('A'..'Z').to_a)
	.map_with_index { |item, i| {item, i + 1} }
	.to_h

def intersect(sets)
	sets.reduce { |acc, set| acc & set }.first
end

def priority(items)
	items.sum { |item| PRIORITY_MAP[item] }
end

priority_items = rucksacks.map { |rucksack|
	compartments = rucksack.in_groups_of(rucksack.size // 2)
	intersect(compartments)
}

badges = rucksacks.in_groups_of(3, [] of Char)
	.map { |group| intersect(group) }

puts "Part 1 answer: #{priority(priority_items)}"
puts "Part 2 answer: #{priority(badges)}"
