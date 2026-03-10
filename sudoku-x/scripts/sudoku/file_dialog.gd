extends FileDialog

func _ready():
	file_mode = FileDialog.FILE_MODE_SAVE_FILE
	access = FileDialog.ACCESS_FILESYSTEM
	filters = PackedStringArray(["*.txt"])
