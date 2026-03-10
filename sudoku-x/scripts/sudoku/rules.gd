class_name Rules
extends RefCounted

func is_legal_move(r: int, c: int, v: int, grid: Grid) -> bool:
	if grid.is_fixed(r, c):
		print("fixed spot")
		return false
	
	for col in range(9):
		if col != c and grid.get_value(r,col) == v:
			print("duplicate in row")
			return false

	for row in range(9):
		if row != r and grid.get_value(row,c) == v:
			print("duplicate in column")
			return false
			
	var start_row = (r / 3) * 3
	var start_col = (c / 3) * 3
	
	for row in range(start_row, start_row + 3):
		for col in range(start_col, start_col + 3):
			if (row != r or col != c) and grid.get_value(row, col) == v:
				print("duplicate in 3x3")
				return false

	if r == c:
		for i in range(9):
			if i != r and grid.get_value(i, i) == v:
				print("duplicate in diag right")
				return false
	if r + c == 8:
		for i in range(9):
			if i != r and grid.get_value(i, 8 - i) == v:
				print("duplicate in diag left")
				return false
		
	return true
	
func is_valid_unit(values: Array) -> bool:
	if values.size() != 9:
		return false
	
	var seen := {}
	
	for v in values:
		if v < 1 or v > 9:
			return false
		if seen.has(v):
			return false
		seen[v] = true
	
	return true

func check_win(grid: Grid) -> bool:
	# all cells must be filled
	for r in range(9):
		for c in range(9):
			if grid.get_value(r, c) == 0:
				return false
	
	for r in range(9):
		var row_values := []
		for c in range(9):
			row_values.append(grid.get_value(r, c))
		if !is_valid_unit(row_values):
			return false
	
	for c in range(9):
		var col_values := []
		for r in range(9):
			col_values.append(grid.get_value(r, c))
		if !is_valid_unit(col_values):
			return false
	
	for start_row in range(0, 9, 3):
		for start_col in range(0, 9, 3):
			var box_values := []
			for r in range(start_row, start_row + 3):
				for c in range(start_col, start_col + 3):
					box_values.append(grid.get_value(r, c))
			if !is_valid_unit(box_values):
				return false
	
	var diag1 := []
	for i in range(9):
		diag1.append(grid.get_value(i, i))
	if !is_valid_unit(diag1):
		return false
	
	var diag2 := []
	for i in range(9):
		diag2.append(grid.get_value(i, 8 - i))
	if !is_valid_unit(diag2):
		return false
	
	return true

func is_valid_starting_grid(grid) -> Dictionary:
	for r in range(9):
		for c in range(9):
			var v = grid.get_value(r, c)
			if v == 0:
				continue
			
			var result = _is_legal_given(r, c, v, grid)
			if !result["ok"]:
				return result
	
	return {"ok": true, "error": ""}


func _is_legal_given(r: int, c: int, v: int, grid: Grid) -> Dictionary:
	for col in range(9):
		if col != c and grid.get_value(r, col) == v:
			return {
				"ok": false,
				"error": "Illegal puzzle: duplicate %d in row %d." % [v, r + 1]
			}

	for row in range(9):
		if row != r and grid.get_value(row, c) == v:
			return {
				"ok": false,
				"error": "Illegal puzzle: duplicate %d in column %d." % [v, c + 1]
			}

	# 3x3 box
	var start_row = int(r / 3) * 3
	var start_col = int(c / 3) * 3
	
	for row in range(start_row, start_row + 3):
		for col in range(start_col, start_col + 3):
			if (row != r or col != c) and grid.get_value(row, col) == v:
				return {
					"ok": false,
					"error": "Illegal puzzle: duplicate %d in 3x3 box." % [v, r + 1, c + 1]
				}

	if r == c:
		for i in range(9):
			if i != r and grid.get_value(i, i) == v:
				return {
					"ok": false,
					"error": "Illegal puzzle: duplicate %d on main diagonal." % v
				}
				
	if r + c == 8:
		for i in range(9):
			if i != r and grid.get_value(i, 8 - i) == v:
				return {
					"ok": false,
					"error": "Illegal puzzle: duplicate %d on anti-diagonal." % v
				}

	return {"ok": true, "error": ""}
