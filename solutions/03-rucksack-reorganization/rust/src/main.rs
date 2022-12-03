use std::collections::HashSet;

// This is horrible.
// Everything about this is terrible.

fn main() {
	
	let input = include_str!("input.txt").trim();
	let rucksacks = input
		.lines()
		.map(|line| line.chars().collect::<Vec<char>>())
		.collect::<Vec<Vec<char>>>();
	
	let priority_items = rucksacks
		.iter()
		.cloned()
		.map(|rucksack| {
			let compartments = rucksack
				.chunks(rucksack.len() / 2)
				.map(|compartment| compartment.iter().cloned().collect())
				.collect();
			return intersect(compartments);
		})
		.collect();
	
	let badges = rucksacks
		.chunks(3)
		.map(|group|
			// why
			intersect(group.iter().map(|rucksack| rucksack.iter().cloned().collect()).collect())
		)
		.collect();
	
	println!("Part 1 answer: {}", total_priority(priority_items));
	println!("Part 2 answer: {}", total_priority(badges));
	
}

fn total_priority(items: Vec<char>) -> u32 {
	return items.into_iter().map(|item| get_priority(item)).sum();
}

fn get_priority(item: char) -> u32 {
	return match item {
		'a'..='z' => (item as u32) - ('a' as u32) + 1,
		'A'..='Z' => (item as u32) - ('A' as u32) + 27,
		_ => unreachable!(),
	};
}

fn intersect(sets: Vec<HashSet<char>>) -> char {
	// jesus christ
	return sets
		.into_iter()
		.reduce(|acc, set| acc.intersection(&set).cloned().collect())
		.unwrap()
		.into_iter()
		.next()
		.unwrap();
}
