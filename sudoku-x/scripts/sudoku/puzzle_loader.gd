class_name PuzzleLoader
extends RefCounted

var rules := Rules.new()

func load_puzzle(path: String) -> Array:
	if !FileAccess.file_exists(path):
		push_error("Puzzle file not found: " + path)
		return []
	
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Could not open file: " + path)
		return []
	
	var lines: Array = []
	while !file.eof_reached():
		var line = file.get_line().strip_edges()
		if line != "":
			lines.append(line)
	
	if lines.size() != 9:
		push_error("Puzzle must have exactly 9 non-empty lines.")
		return []
	
	var puzzle: Array = []
	
	for r in range(9):
		var line: String = lines[r]
		
		if line.length() != 9:
			push_error("Line %d must have exactly 9 characters." % (r + 1))
			return []
		
		var row: Array = []
		
		for c in range(9):
			var ch := line[c]
			
			if ch == ".":
				row.append(0)
			elif ch >= "1" and ch <= "9":
				row.append(int(ch))
			else:
				push_error("Invalid character '%s' at row %d col %d." % [ch, r + 1, c + 1])
				return []
		
		puzzle.append(row)
	
	return puzzle


func save_puzzle(path: String, grid: Grid) -> bool:
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		push_error("Could not open file for writing: " + path)
		return false
	
	for r in range(9):
		var line := ""
		
		for c in range(9):
			var value := grid.get_value(r, c)
			
			if value == 0:
				line += "."
			elif value >= 1 and value <= 9:
				line += str(value)
			else:
				push_error("Invalid value '%s' at row %d col %d." % [str(value), r + 1, c + 1])
				return false
		
		file.store_line(line)
	
	return true
