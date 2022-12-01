// off to a bad start

fn main() {
	
	let input = include_str!("input.txt").trim();
	let mut calories: Vec<i32> =
		input.split("\n\n").map(|elf|
			elf.lines().map(|food|
				food.parse::<i32>().unwrap()
			).sum()
		).collect();
	
	calories.sort();
	calories.reverse();
	let top_3 = &calories[0..3];
	
	println!("Part 1 answer: {}", top_3[0]);
	println!("Part 2 answer: {}", top_3.iter().sum::<i32>())
	
}
