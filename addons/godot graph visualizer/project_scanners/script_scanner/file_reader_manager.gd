@tool
extends Node
class_name FileReaderManager

signal line_reached(line: String, from_file: String)

func _read_file(path: String) -> void:
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	if not file:
		push_error("Error: Unable to open file \'%s\'", path)
		return
	
	while not file.eof_reached():
		var line: String = file.get_line()
		if line: line_reached.emit(line, path)

	file.close()
