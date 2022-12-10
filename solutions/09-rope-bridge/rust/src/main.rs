use std::collections::HashSet;

#[derive(Copy, Clone, Hash, Eq, PartialEq)]
struct Point {
	x: i32,
	y: i32,
}

fn main() {
	
	let input = include_str!("input.txt").trim();
	let steps = input.lines().map(|line| line.split_once(" ").unwrap());
	
	let mut rope = [Point {x: 0, y: 0}; 10];
	
	let mut visited = rope.map(|pos| HashSet::from([pos]));
	
	for (dir, dist) in steps {
		let dist: i32 = dist.parse().unwrap();
		for _ in 0..dist {
			
			match dir {
				"R" => { rope[0].x += 1 },
				"L" => { rope[0].x -= 1 },
				"D" => { rope[0].y += 1 },
				"U" => { rope[0].y -= 1 },
				_ => unreachable!(),
			}
			
			for i in 1..10 {
				let delta_x = rope[i - 1].x - rope[i].x;
				let delta_y = rope[i - 1].y - rope[i].y;
				
				if delta_x.abs() >= 2 || delta_y.abs() >= 2 {
					rope[i].x += delta_x.signum();
					rope[i].y += delta_y.signum();
				}
				
				visited[i].insert(rope[i]);
			}
			
		}
	}
	
	println!("Part 1 answer: {}", visited[1].len());
	println!("Part 2 answer: {}", visited[9].len());
	
}
