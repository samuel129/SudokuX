extends Panel

@onready var label = $Label
@onready var value = int(name.substr(5))
var row: int
var col: int
var normal_style: StyleBoxFlat
var hover_style: StyleBoxFlat
var invalid_style: StyleBoxFlat
signal numpad_selected(value, numpad_cell)

func _ready():	
	normal_style = get_theme_stylebox("panel").duplicate()
	hover_style = normal_style.duplicate()
	invalid_style = normal_style.duplicate()
	hover_style.bg_color = Color(135/255, 135/255, 135/255, .5)
	invalid_style.bg_color = Color(1, 200/255, 200/255, .5)

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		numpad_selected.emit(value, self)

func _on_mouse_entered() -> void:
	add_theme_stylebox_override("panel", hover_style)

func _on_mouse_exited() -> void:
	add_theme_stylebox_override("panel", normal_style)

func flash_red() -> void:
	add_theme_stylebox_override("panel", invalid_style)
	await get_tree().create_timer(0.1).timeout
	add_theme_stylebox_override("panel", normal_style)
