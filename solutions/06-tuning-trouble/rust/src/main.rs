use std::collections::HashSet;

// Decent.

fn main() {
	
	let input = include_str!("input.txt").trim();
	let data: Vec<char> = input.chars().collect();
	
	println!("Part 1 answer: {}", first_uniq_seq(&data, 4));
	println!("Part 2 answer: {}", first_uniq_seq(&data, 14));
	
}

fn first_uniq_seq(data: &Vec<char>, len: usize) -> usize {
	for (i, seq) in data.windows(len).enumerate() {
		let set: HashSet<char> = seq.iter().copied().collect();
		if set.len() == len {
			return i + len;
		}
	}
	return 0;
}
