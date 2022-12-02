// Rust not having top-level constant maps,
// nor having lookup literals at all is very dumb.

fn get_score_value(b: &str) -> i32 {
	return match b {
		"X" => 1,
		"Y" => 2,
		"Z" => 3,
		_ => panic!(),
	};
}

fn get_lose_choice(a: &str) -> &str {
	return match a {
		"A" => "Z",
		"B" => "X",
		"C" => "Y",
		_ => panic!(),
	};
}

fn get_draw_choice(a: &str) -> &str {
	return match a {
		"A" => "X",
		"B" => "Y",
		"C" => "Z",
		_ => panic!(),
	};
}

fn get_win_choice(a: &str) -> &str {
	return match a {
		"A" => "Y",
		"B" => "Z",
		"C" => "X",
		_ => panic!(),
	};
}

fn get_choice_fn(b: &str) -> fn(a: &str) -> &str {
	return match b {
		"X" => get_lose_choice,
		"Y" => get_draw_choice,
		"Z" => get_win_choice,
		_ => panic!(),
	};
}

fn main() {
	
	let input = include_str!("input.txt").trim();
	let guide = input.lines().map(|rule| rule.split(" "));
	
	let mut score   = 0;
	let mut score_2 = 0;
	
	for mut rule in guide {
		let a = rule.next().unwrap();
		let b = rule.next().unwrap();
		
		score   += get_score(a, b);
		score_2 += get_score_2(a, b);
	}
	
	println!("Part 1 answer: {}", score);
	println!("Part 2 answer: {}", score_2);
	
}

fn get_score(a: &str, b: &str) -> i32 {
	return get_score_value(b) + win_score(a, b);
}

fn get_score_2(a: &str, b: &str) -> i32 {
	let choice_fn = get_choice_fn(b);
	let choice = choice_fn(a);
	return get_score(a, choice);
}

fn win_score(a: &str, b: &str) -> i32 {
	// Rust's matching can't handle dynamic values,
	// and there's no switch/case statements
	if b == get_win_choice(a) {
		return 6;
	} else if b == get_draw_choice(a) {
		return 3;
	} else {
		return 0;
	}
}
