output = File.read("input.txt").strip
blocks = output.split("$").map(&.lines.map(&.strip)).reject(&.empty?)
blocks.shift # cd /

# This sucked.

DIR_SIZES = Array(UInt32).new

class ElfDir
	
	getter   name   : String
	getter   parent : ElfDir | Nil
	property size   : UInt32
	@subdirs        : Array(ElfDir)
	
	def initialize(@name, @parent = nil)
		@size = 0
		@subdirs = Array(ElfDir).new
	end
	
	def add_subdir(dir : ElfDir)
		@subdirs << dir
	end
	
	def get_subdir(dir_name : String)
		@subdirs.find { |subdir| subdir.name == dir_name }.not_nil!
	end
	
	def get_size
		size = @size + @subdirs.sum(0, &.get_size)
		DIR_SIZES << size
		return size
	end
	
end

ROOT_DIR = ElfDir.new("/")
current_dir = ROOT_DIR

blocks.each do |block|
	cmd = block.shift.split
	
	case cmd.shift
	when "cd"
		dir_name = cmd.shift
		
		if dir_name == ".."
			current_dir = current_dir.parent.not_nil!
		else
			current_dir = current_dir.get_subdir(dir_name)
		end
	when "ls"
		block.each do |out_line|
			item = out_line.split
			if item.first == "dir"
				subdir = ElfDir.new(item.last, current_dir)
				current_dir.add_subdir(subdir)
			else
				size = item.first.to_u32
				current_dir.size += size
			end
		end
	end
end

unused = 70_000_000 - ROOT_DIR.get_size

under_100k = DIR_SIZES.select { |size| size <= 100_000 }
freeable   = DIR_SIZES.select { |size| unused + size >= 30_000_000 }

puts "Part 1 answer: #{under_100k.sum}"
puts "Part 2 answer: #{freeable.min}"
