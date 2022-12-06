extern crate itertools;
use itertools::Itertools;
use std::collections::VecDeque;

// Eh.

fn main() {
	
	let input = include_str!("input.txt");
	let (drawing, instructions) = input.split_once("\n\n").unwrap();
	
	let mut towers: Vec<VecDeque<char>> = vec!();
	
	let line_len = drawing.lines().next().unwrap().len();
	for col_i in (1..line_len).step_by(4) {
		let mut tower: VecDeque<char> = VecDeque::new();
		for line in drawing.lines().dropping_back(1) {
			let c = line.chars().nth(col_i).unwrap();
			if c != ' ' {
				tower.push_front(c);
			}
		}
		towers.push(tower);
	}
	
	let mut towers_2 = towers.clone();
	
	for instr in instructions.lines() {
		let mut pieces = instr.split(" ");
		// ew
		let amount: usize = pieces.nth(1).unwrap().parse().unwrap();
		let from: usize = pieces.nth(1).unwrap().parse().unwrap();
		let to: usize = pieces.nth(1).unwrap().parse().unwrap();
		
		for _ in 0..amount {
			let c = towers.get_mut(from - 1).unwrap().pop_back().unwrap();
			towers.get_mut(to - 1).unwrap().push_back(c);
		}
		
		let mut hold: VecDeque<char> = VecDeque::new();
		for _ in 0..amount {
			let c = towers_2.get_mut(from - 1).unwrap().pop_back().unwrap();
			hold.push_front(c);
		}
		towers_2.get_mut(to - 1).unwrap().append(&mut hold);
	}
	
	println!("Part 1 answer: {}", tops(towers));
	println!("Part 2 answer: {}", tops(towers_2));
	
}

fn tops(towers: Vec<VecDeque<char>>) -> String {
	return towers
		.into_iter()
		.map(|mut tower| tower.pop_back().unwrap())
		.join("");
}

