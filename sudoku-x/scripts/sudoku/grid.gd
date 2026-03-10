class_name Grid
extends RefCounted

var fixed_values := []
var current_values := []
var move_history := []
var undo_history := []

func _init(puzzle: Array):
	for r in range(9):
		fixed_values.append([])
		current_values.append([])
		for c in range(9):
			var v = puzzle[r][c]
			fixed_values[r].append(v)
			current_values[r].append(v)

func get_value(r: int, c: int) -> int:
	return current_values[r][c]
	
func set_value(r: int, c: int, v) -> void:
	var old_value = current_values[r][c]
	if old_value == v:
		return
	
	move_history.append({
		"row": r,
		"col": c,
		"old_value": old_value,
		"new_value": v
	})
	
	current_values[r][c] = v
	
	undo_history.clear()
	
func clear_cell(r: int, c: int) -> void:
	current_values[r][c] = 0

func undo() -> void:
	print(move_history)
	if move_history.is_empty():
		return
		
	var move = move_history.pop_back()
	current_values[move.row][move.col] = move.old_value
	
	undo_history.append(move)

func redo() -> void:
	if undo_history.is_empty():
		return
		
	var move = undo_history.pop_back()
	current_values[move.row][move.col] = move.new_value
	
	move_history.append(move)

func is_fixed(r: int, c: int) -> bool:
	return  fixed_values[r][c] != 0
	
func is_empty(r: int, c: int) -> bool:
	return current_values[r][c] == 0
	
func print_at(r: int, c: int) -> void:
	print(current_values[r][c])
