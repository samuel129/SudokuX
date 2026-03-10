extends Node2D

@onready var renderer = $Renderer
@onready var numpad = $Numpad
var current_state: GameState = GameState.MAIN_MENU
var rules
var grid
var loaded_puzzle
var puzzle_loader
var listening_for_click
var clicked_cell = Vector2i()

enum GameState {
	MAIN_MENU,
	PLAYING,
	PAUSED,
	COMPLETED,
	HELP
}

const base_grid = [
[0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0]
]

func _ready():
	puzzle_loader = PuzzleLoader.new()
	var puzzle_path := get_startup_puzzle_path()
	if puzzle_loader.load_puzzle(puzzle_path) == []:
		loaded_puzzle = base_grid
	else:
		loaded_puzzle = puzzle_loader.load_puzzle(puzzle_path)
	grid = Grid.new(loaded_puzzle)
	rules = Rules.new()
	
	if !rules.is_valid_starting_grid(grid).ok:
		push_error("Puzzle violates Sudoku X rules.")
		return []
		
	await get_tree().process_frame #Wait one frame for deferred add_child call for all cells
	renderer.render(grid)
	renderer.cell_clicked.connect(_on_cell_clicked)
	for child in numpad.get_children():
		child.numpad_selected.connect(_on_numpad_clicked)
	
func get_startup_puzzle_path() -> String:
	var exe_dir := OS.get_executable_path().get_base_dir()
	var grading_path := exe_dir.path_join("gradingboard.txt")
	
	if FileAccess.file_exists(grading_path):
		return grading_path
	
	return "res://puzzles/easy_puzzle.txt"
	
func _on_cell_clicked(row: int, col: int) -> void:
	if !grid.is_fixed(row, col):
		clicked_cell = Vector2i(row, col)
		var mouse_pos = get_viewport().get_mouse_position()
		
		if mouse_pos.y < get_viewport().get_visible_rect().size.y / 2:
			numpad.position = mouse_pos + Vector2(73,96)
			numpad.show()
			get_tree().call_group("cells", "disable_listening_for_hover")
		else:
			numpad.position = mouse_pos - Vector2(0,96) + Vector2(73,0)
			numpad.show()
			get_tree().call_group("cells", "disable_listening_for_hover")

func _on_numpad_clicked(value: int, numpad_cell: Panel) -> void:
	if value == 0: #0 = X value
		grid.clear_cell(clicked_cell.x, clicked_cell.y)
		renderer.render(grid)
		numpad.hide()
		get_tree().call_group("cells", "enable_listening_for_hover")
	elif rules.is_legal_move(clicked_cell.x, clicked_cell.y, value, grid):
		grid.set_value(clicked_cell.x, clicked_cell.y, value)
		renderer.render(grid)
		numpad.hide()
		get_tree().call_group("cells", "enable_listening_for_hover")
		renderer.cells[clicked_cell.x][clicked_cell.y].reset_style()
		if rules.check_win(grid):
			print("You win!")
	else:
		numpad_cell.flash_red()
		return

func _on_exit_numpad_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		numpad.hide()
		get_tree().call_group("cells", "enable_listening_for_hover")
		renderer.cells[clicked_cell.x][clicked_cell.y].reset_style()

func _on_undo_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		grid.undo()
		renderer.render(grid)

func _on_redo_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		grid.redo()
		renderer.render(grid)

func _on_load_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		pass # Replace with function body.

func _on_save_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		open_save_dialog()

func open_save_dialog():
	$FileDialog.popup_centered()

func _on_file_dialog_file_selected(path: String) -> void:
	var loader := PuzzleLoader.new()
	loader.save_puzzle(path, grid)
