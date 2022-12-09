fn main() {
	
	let input = include_str!("input.txt").trim();
	let grid: Vec<Vec<u32>> = input
		.lines()
		.map(|line| line.chars().map(|c| c.to_digit(10).unwrap()))
		.map(|line| line.collect())
		.collect();
	
	let mut visible_count = 0;
	let mut scenic_scores: Vec<u32> = vec!();
	
	let y_size = grid.len();
	for y in 0..y_size {
		let x_size = grid.get(y).unwrap().len();
		for x in 0..x_size {
			
			let height = get_coord(&grid, x, y);
			
			let scan_left = (0..x)
				.rev()
				.map(|scan_x| get_coord(&grid, scan_x, y))
				.collect::<Vec<u32>>();
			let scan_right = (x + 1..x_size)
				.map(|scan_x| get_coord(&grid, scan_x, y))
				.collect::<Vec<u32>>();
			
			let scan_up = (0..y)
				.rev()
				.map(|scan_y| get_coord(&grid, x, scan_y))
				.collect::<Vec<u32>>();
			let scan_down = (y + 1..y_size)
				.map(|scan_y| get_coord(&grid, x, scan_y))
				.collect::<Vec<u32>>();
			
			let scans = [scan_left, scan_right, scan_up, scan_down];
			
			let visible = scans.iter()
				.any(|scan| scan.iter()
					.all(|h| h < &height)
				);
			if visible {
				visible_count += 1;
			}
			
			let scenic_score = scans.iter()
				.map(|scan| scan_score(&scan, height))
				.product();
			scenic_scores.push(scenic_score);
			
		}
	}
	
	println!("Part 1 answer: {}", visible_count);
	println!("Part 2 answer: {}", scenic_scores.iter().max().unwrap());
	
}

fn get_coord(grid: &Vec<Vec<u32>>, x: usize, y: usize) -> u32 {
	return *grid.get(y).unwrap().get(x).unwrap();
}

fn scan_score(scan: &Vec<u32>, max_height: u32) -> u32 {
	let mut score = 0;
	for h in scan {
		score += 1;
		if h >= &max_height {
			break;
		}
	}
	return score;
}
