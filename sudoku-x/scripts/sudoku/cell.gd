extends Panel

@onready var label = $Label
var row: int
var col: int
var normal_style: StyleBoxFlat
var hover_style: StyleBoxFlat
var listening_for_hover: bool = true
var value := 0
var fixed: bool
signal clicked(row, col)

func _ready():
	normal_style = get_theme_stylebox("panel").duplicate()
	hover_style = normal_style.duplicate()
	hover_style.bg_color = Color(135/255, 135/255, 135/255, .5)

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if !fixed:
			clicked.emit(row, col)
			$Label.add_theme_color_override("font_color", Color(.2, .3, .5)) # red

func set_value(v):
	if v == 0:
		label.text = ""
	else:
		label.text = str(v)

func _on_mouse_entered() -> void:
	if listening_for_hover:
		add_theme_stylebox_override("panel", hover_style)

func _on_mouse_exited() -> void:
	if listening_for_hover:
		add_theme_stylebox_override("panel", normal_style)
		
func reset_style() -> void:
	add_theme_stylebox_override("panel", normal_style)

func disable_listening_for_hover() -> void:
	listening_for_hover = false

func enable_listening_for_hover() -> void:
	listening_for_hover = true
