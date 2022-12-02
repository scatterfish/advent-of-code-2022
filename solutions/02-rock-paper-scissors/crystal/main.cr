guide = File.read_lines("input.txt").map(&.split)

# I didn't like this puzzle.

SCORE_MAP = {
	"X": 1,
	"Y": 2,
	"Z": 3,
}

LOSE_MAP = {
	"A": "Z",
	"B": "X",
	"C": "Y",
}

DRAW_MAP = {
	"A": "X",
	"B": "Y",
	"C": "Z",
}

WIN_MAP = {
	"A": "Y",
	"B": "Z",
	"C": "X",
}

CHOICE_MAP = {
	"X": LOSE_MAP,
	"Y": DRAW_MAP,
	"Z": WIN_MAP,
}

def score(a, b)
	SCORE_MAP[b] + win_score(a, b)
end

def score_2(a, b)
	choice = CHOICE_MAP[b][a]
	return score(a, choice)
end

def win_score(a, b)
	return 6 if b == WIN_MAP[a]
	return 3 if b == DRAW_MAP[a]
	return 0
end

puts "Part 1 answer: #{guide.map { |(a, b)| score(a, b)   }.sum}"
puts "Part 2 answer: #{guide.map { |(a, b)| score_2(a, b) }.sum}"
