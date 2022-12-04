use std::ops::Range;

// Maybe less awful? Slightly?

fn main() {
	
	let input = include_str!("input.txt").trim();
	let ranges: Vec<(Range<i32>, Range<i32>)> = input
		.lines()
		.map(|line| line.split(","))
		.map(|pair| pair
			.map(|bounds| bounds.split("-"))
			.map(|bounds| bounds.map(|i| i.parse::<i32>().unwrap()))
			.map(|bounds| bounds.collect::<Vec<i32>>())
			.map(|bounds| (bounds[0]..bounds[1]))
			.collect::<Vec<Range<i32>>>()
		)
		.map(|ranges| (ranges[0].clone(), ranges[1].clone()))
		.collect();
	
	let mut contain = 0;
	let mut overlap = 0;
	
	for pair in ranges {
		if range_contain(&pair) {
			contain += 1;
			overlap += 1;
		} else if range_overlap(&pair) {
			overlap += 1;
		}
	}
	
	println!("Part 1 answer: {}", contain);
	println!("Part 2 answer: {}", overlap);
	
}

fn range_contain(pair: &(Range<i32>, Range<i32>)) -> bool {
	let (a, b) = pair;
	return bounds_contain(&a, &b) || bounds_contain(&b, &a);
}

fn bounds_contain(a: &Range<i32>, b: &Range<i32>) -> bool {
	a.start <= b.start && a.end >= b.end
}

fn range_overlap(pair: &(Range<i32>, Range<i32>)) -> bool {
	let (a, b) = pair;
	return bounds_overlap(&a, &b) || bounds_overlap(&b, &a);
}

fn bounds_overlap(a: &Range<i32>, b: &Range<i32>) -> bool {
	a.start <= b.end && a.end >= b.start
}
