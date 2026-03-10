class_name Units
extends RefCounted

var rows := []
var cols := []
var boxes := []
var diagonals := []
var all_units := []

func _init():
	_build_rows()
	_build_cols()
	_build_boxes()
	_build_diagonals()
	all_units = rows + cols + boxes + diagonals

func _build_rows() -> void:
	for r in range(9):
		var row := []
		for c in range(9):
			row.append(Vector2i(r, c))
		rows.append(row)

func _build_cols() -> void:
	for c in range(9):
		var col := []
		for r in range(9):
			col.append(Vector2i(r, c))
		cols.append(col)

func _build_boxes() -> void:
	for box_row in range(0, 9, 3):
		for box_col in range(0, 9, 3):
			var box := []
			for r in range(box_row, box_row + 3):
				for c in range(box_col, box_col + 3):
					box.append(Vector2i(r, c))
			boxes.append(box)

func _build_diagonals() -> void:
	var main_diag := []
	var anti_diag := []
	for i in range(9):
		main_diag.append(Vector2i(i, i))
		anti_diag.append(Vector2i(i, 8 - i))
	diagonals.append(main_diag)
	diagonals.append(anti_diag)
