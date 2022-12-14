calories = File.read("input.txt").split("\n\n").map(&.split.sum(&.to_i))

sorted = calories.sort.reverse

puts "Part 1 answer: #{sorted.first}"
puts "Part 2 answer: #{sorted.first(3).sum}"
