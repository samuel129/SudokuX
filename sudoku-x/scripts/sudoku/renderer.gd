extends Node

const cell_scene = preload("res://scenes/cell.tscn")
var cells := []
var numpad_cells := []
const starting_position_board = Vector2(21,21)
signal cell_clicked(row, col)
signal number_selected(row, col, value)

func _ready():
	for r in range(9):
		cells.append([])
		for c in range(9):
			var cell = cell_scene.instantiate()
			
			cell.clicked.connect(_on_cell_clicked)
			cell.row = r
			cell.col = c
			cell.get_node("Label").add_theme_color_override("font_color", Color(0, 0, 0)) # red
			cell.position = Vector2(
				starting_position_board.x + (c * 48) + (c / 3 * 3), 
				starting_position_board.y + (r * 48) + (r / 3 * 3)
			) 
			
			add_child.call_deferred(cell)
			cells[r].append(cell)

func _on_cell_clicked(row, col) -> void:
	cell_clicked.emit(row, col)
	return

func _on_number_selected(row, col, value):
	number_selected.emit(row, col, value)
	return

func render(grid):
	for r in range(9):
		for c in range(9):
			var v = grid.get_value(r, c)
			cells[r][c].set_value(v)
