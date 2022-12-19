valves = File.read_lines("input.txt").map { |line|
	valve_names = unwrap_scan(line.scan(/[A-Z]{2}/))
	this_valve_name = valve_names.shift
	rate = unwrap_scan(line.scan(/\d+/)).first.to_i
	Valve.new(this_valve_name, rate, valve_names)
}

# This is a lot.

def unwrap_scan(scan)
	scan.map(&.[0])
end

struct Valve
	property name  : String
	property rate  : Int32
	property links : Array(String)
	
	def initialize(@name, @rate, @links)
	end
end

struct State
	property time       : Int32 # depth
	property valve_name : String
	property opened     : Set(String)
	property rate       : Int32
	property score      : Int32
	
	def initialize(@time, @valve_name, @opened, @rate, @score)
	end
	
	def future_score(time_limit)
		score + (rate * (time_limit - time + 1))
	end
end

VALVE_MAP = Hash(String, Valve).new
valves.each do |valve|
	VALVE_MAP[valve.name] = valve
end

macro push_links_to_queue(valve, steps)
	{{valve}}.links.each do |link_name|
		linked_valve = VALVE_MAP[link_name]
		unless seen.includes?(linked_valve)
			seen << linked_valve
			queue << {linked_valve, {{steps}} + 1}
		end
	end
end

def valve_distance(start_valve, target)
	return 0 if start_valve == target
	seen = Set{start_valve}
	queue = Deque(Tuple(Valve, Int32)).new
	
	push_links_to_queue(start_valve, 0)
	
	until queue.empty?
		valve, steps = queue.shift
		return steps if valve.name == target.name
		push_links_to_queue(valve, steps)
	end
	raise "no path found"
end

DISTANCE_MAP = Hash(Tuple(String, String), Int32).new

target_valves = valves.select { |valve| valve.rate > 0 }

valves.each do |valve|
	target_valves.each do |target|
		DISTANCE_MAP[{valve.name, target.name}] = valve_distance(valve, target)
	end
end

initial_state = State.new(1, "AA", Set(String).new, 0, 0)
states = Deque(State).new([initial_state])
all_states = Set(State).new

until states.empty?
	state = states.pop
	next if state.time == 30
	
	all_states << state
	
	valve = VALVE_MAP[state.valve_name]
	
	if !state.opened.includes?(valve.name) && valve.rate > 0
		states << State.new(
			state.time + 1,
			valve.name,
			state.opened.dup << state.valve_name,
			state.rate + valve.rate,
			state.score + state.rate,
		)
	else
		target_valves.each do |target|
			next if state.opened.includes?(target.name)
			distance = DISTANCE_MAP[{valve.name, target.name}]
			next if state.time + distance >= 30
			states << State.new(
				state.time + distance,
				target.name,
				state.opened,
				state.rate,
				state.score + (state.rate * distance),
			)
		end
	end
	
end

limited_states = all_states.select { |state| state.time < 26 }

best_scores = limited_states
	.group_by(&.opened)
	.map { |opened, states|
		{open: opened, score: states.max_of(&.future_score(26))}
	}
	.sort_by(&.[:score])
	.last(100) # only consider top 100 for performance

max_combined_score = best_scores
	.each_combination(2, reuse: true)
	.max_of { |(me, ele)|
		if me[:open].none? { |valve_name| ele[:open].includes?(valve_name) }
			me[:score] + ele[:score]
		else
			0
		end
	}

puts "Part 1 solution: #{all_states.max_of(&.future_score(30))}"
puts "Part 2 solution: #{max_combined_score}"
