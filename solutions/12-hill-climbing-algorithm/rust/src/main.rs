extern crate priority_queue;
use priority_queue::DoublePriorityQueue;
use std::collections::HashSet;

fn main() {
	
	let input = include_str!("input.txt").trim();
	let grid = input
		.lines()
		.map(|line| line.chars().collect::<Vec<char>>())
		.collect::<Vec<Vec<char>>>();
	
	let mut start_pos = (0, 0);
	let mut end_pos = (0, 0);
	let mut start_candidates: HashSet<(usize, usize)> = HashSet::new();
	
	let y_size = grid.len();
	for y in 0..y_size {
		let x_size = grid.get(y).unwrap().len();
		for x in 0..x_size {
			
			let coords = (x, y);
			let height_char = get_coord(&grid, x, y);
			match height_char {
				'S' => {
					start_pos = coords;
					start_candidates.insert(coords);
				},
				'E' => { end_pos = coords; },
				'a' => { start_candidates.insert(coords); }
				_ => {},
			};
			
		}
	}
	
	let start_to_end =
		dijkstra(&grid, start_pos, HashSet::from([end_pos]), false);
	let end_to_min =
		dijkstra(&grid, end_pos, start_candidates, true);
	
	println!("Part 1 answer: {}", start_to_end.unwrap());
	println!("Part 2 answer: {}", end_to_min.unwrap());
	
}

fn get_height(height_char: char) -> i64 {
	match height_char {
		'S' => get_height('a'),
		'E' => get_height('z'),
		'a'..='z' => i64::from(
			(height_char as u32) - ('a' as u32)
		),
		_ => unreachable!(),
	}
}

fn get_coord(grid: &Vec<Vec<char>>, x: usize, y: usize) -> char {
	*grid.get(y).unwrap().get(x).unwrap()
}

fn get_neighbors(
	grid: &Vec<Vec<char>>,
	x: usize,
	y: usize,
) -> Vec<(usize, usize)> {
	let mut neighbors: Vec<(usize, usize)> = vec!();
	let y_size = grid.len();
	let x_size = grid.get(y).unwrap().len();
	if x > 0          { neighbors.push((x - 1, y)) }
	if x < x_size - 1 { neighbors.push((x + 1, y)) }
	if y > 0          { neighbors.push((x, y - 1)) }
	if y < y_size - 1 { neighbors.push((x, y + 1)) }
	return neighbors;
}

fn dijkstra(
	grid: &Vec<Vec<char>>,
	start: (usize, usize),
	targets: HashSet<(usize, usize)>,
	backwards: bool,
) -> Option<u32> {
	let mut seen: HashSet<(usize, usize)> = HashSet::new();
	let mut queue = DoublePriorityQueue::new();
	
	queue.push(start, 0);
	while !queue.is_empty() {
		let (coords, steps) = queue.pop_min().unwrap();
		
		if seen.contains(&coords) {
			continue;
		}
		if targets.contains(&coords) {
			return Some(steps);
		}
		
		seen.insert(coords);
		let (x, y) = coords;
		let height = get_height(get_coord(&grid, x, y));
		
		let neighbors = get_neighbors(&grid, x, y);
		for (n_x, n_y) in neighbors {
			let n_height = get_height(get_coord(&grid, n_x, n_y));
			let delta =
				(n_height - height) * (if backwards { -1 } else { 1 });
			if delta <= 1 {
				queue.push((n_x, n_y), steps + 1);
			}
		}
	}
	return None;
}
