notes = File.read("input.txt").strip.split("\n\n").map(&.lines.map(&.strip))

# Math :/

struct Monkey
	property starting_items = Array(UInt64).new
	property op_str         = ""
	property div_val        = 0_u64
	property true_target    = 0_u64
	property false_target   = 0_u64
end

def scan_numbers(string)
	string.scan(/\d+/).map(&.[0]).map(&.to_u64)
end

monkeys = notes.map { |note|
	monkey = Monkey.new
	monkey.starting_items = scan_numbers(note[1])
	monkey.op_str         = note[2].lchop("Operation: new = ")
	monkey.div_val        = scan_numbers(note[3]).first
	monkey.true_target    = scan_numbers(note[4]).first
	monkey.false_target   = scan_numbers(note[5]).first
	monkey
}

def calc_op_str(worry_level, op_str)
	lhs, op, rhs = op_str.gsub("old", worry_level).split
	if op == "+"
		return lhs.to_u64 + rhs.to_u64
	else
		return lhs.to_u64 * rhs.to_u64
	end
end

def calc_monkey_business(monkeys, rounds, divisor, modular)
	items = monkeys.map { |monkey| Deque.new(monkey.starting_items) }
	inspections = [0_u64] * monkeys.size
	
	rounds.times do
		monkeys.each_with_index do |monkey, i|
			
			until items[i].empty?
				
				inspections[i] += 1
				
				worry_level = items[i].shift
				new_worry_level = calc_op_str(worry_level, monkey.op_str)
				if modular
					new_worry_level %= divisor
				else
					new_worry_level //= divisor
				end
				
				div_test = (new_worry_level % monkey.div_val == 0)
				target = div_test ? monkey.true_target : monkey.false_target
				items[target] << new_worry_level
				
			end
			
		end
	end
	
	return inspections.sort.last(2).product
end

lcm = monkeys.product(&.div_val)

puts "Part 1 answer: #{calc_monkey_business(monkeys, 20, 3, false)}"
puts "Part 2 answer: #{calc_monkey_business(monkeys, 10_000, lcm, true)}"
