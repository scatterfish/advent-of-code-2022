program = File.read_lines("input.txt").map(&.split)

class Computer
	
	@register = 1
	@cycles   = 0
	@signals  = Array(Int32).new
	@display  = Array(Array(Char)).new(6) { Array.new(40, ' ') }
	
	def run(program)
		program.each do |instr|
			do_cycle
			if instr.first == "addx"
				do_cycle
				@register += instr.last.to_i
			end
		end
	end
	
	def signal_sum
		@signals.sum
	end
	
	def do_cycle
		draw_beam
		@cycles += 1
		@signals << @register * @cycles if (@cycles + 20) % 40 == 0
	end
	
	def draw_beam
		beam_x = @cycles % 40
		beam_y = (@cycles // 40) % 6
		
		delta = @register - beam_x
		@display[beam_y][beam_x] = '\u2588' if delta.abs <= 1
	end
	
	def print_diplay
		puts @display.map(&.join).join("\n")
	end
	
end

computer = Computer.new
computer.run(program)

puts "Part 1 answer: #{computer.signal_sum}"
puts "Part 2 answer:"
computer.print_diplay
