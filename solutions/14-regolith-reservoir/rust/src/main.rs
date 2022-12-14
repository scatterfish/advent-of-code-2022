use std::collections::HashSet;
use std::collections::VecDeque;

fn main() {
	
	let input = include_str!("input.txt").trim();
	let scan: Vec<Vec<Vec<i32>>> = input
		.lines()
		.map(|line| line
			.split(" -> ")
			.map(|coord| coord
				.split(",")
				.map(|num| num.parse::<i32>().unwrap())
				.collect()
			)
			.collect()
		)
		.collect();
	
	let mut world: HashSet<(i32, i32)> = HashSet::new();
	
	for structure in scan {
		for coords in structure.windows(2) {
			
			for axis in [0, 1] {
				let positions = coords
					.iter()
					.map(|coord| coord[axis])
					.collect::<Vec<i32>>();
				let min = *positions.iter().min().unwrap();
				let max = *positions.iter().max().unwrap();
				
				if min == max {
					continue;
				}
				
				for pos in min..(max + 1) {
					if axis == 0 {
						world.insert((pos, coords[1][1]));
					} else {
						world.insert((coords[0][0], pos));
					}
				}
			}
			
		}
	}
	
	let y_max = world.iter().map(|coord| coord.1).max().unwrap();
	
	let mut sand_path: VecDeque<(i32, i32)> = VecDeque::new();
	sand_path.push_back((500, 0));
	
	let mut count = 0;
	let mut first_below_count = 0;
	
	loop {
		
		let mut moved = false;
		
		let (x, y) = *sand_path.back().unwrap();
		
		let fall_pos_list = [
			(x    , y + 1),
			(x - 1, y + 1),
			(x + 1, y + 1),
		];
		
		for fall_pos in fall_pos_list {
			if !world.contains(&fall_pos) {
				sand_path.push_back(fall_pos);
				moved = true;
				break;
			}
		}
		
		let last_y = sand_path.back().unwrap().1;
		
		if !moved {
			count += 1;
		}
		if !moved || last_y == y_max + 2 {
			world.insert(sand_path.pop_back().unwrap());
		}
		if first_below_count == 0 && last_y > y_max {
			first_below_count = count;
		}
		
		if sand_path.is_empty() {
			println!("Part 1 answer: {}", first_below_count);
			println!("Part 2 answer: {}", count);
			break;
		}
		
	}
	
}
