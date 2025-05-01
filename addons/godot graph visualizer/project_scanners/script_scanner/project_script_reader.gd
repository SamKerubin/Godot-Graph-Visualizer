@tool
extends Node

signal line_reached(line: String, from_file: String)

func read_all_scripts() -> void:
	var project_scripts: Array = FileScanner.get_files_by_type(FileTypes.FileType.SCRIPT_FILE)
	for scr: String in project_scripts:
		var read_thread: Thread = Thread.new()
		read_thread.start(
			read_script.bind(scr)
		)

func read_script(path: String) -> void:
	var script: FileAccess = FileAccess.open(path, FileAccess.READ)
	if not script:
		push_error("Error: Unable to open file \'%s\'", path)
		return
	
	var line: String = script.get_line()
	while line:
		line_reached.emit(line, path)
		line = script.get_line()
