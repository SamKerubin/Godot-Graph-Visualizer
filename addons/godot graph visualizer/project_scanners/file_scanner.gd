@tool
extends Node
## [b]A singleton to scan files inside a godot project[/b][br]

## [b]Do not call this function[/b][br][br]
## This function returns all the files in a directory[br]
## See [method get_files_by_type]
func _scan_files_in_directory(path: String) -> Dictionary[FileTypes.FileType, Array]:
	var dir: DirAccess = DirAccess.open(path)

	var files: Dictionary[FileTypes.FileType, Array] = {}

	if not dir:
		push_error("Error: Directory \'%s\' does not exist or have been removed from the main directory" % path)
		return {}
	
	dir.list_dir_begin()
	var file_name: String = dir.get_next()
	while file_name != "":
		if file_name == "." or file_name == "..":
			file_name = dir.get_next()
			continue
		
		var file_path: String = path.path_join(file_name)
		
		if dir.current_is_dir():
			files.merge(_scan_files_in_directory(file_path), true)
		else:
			var file_type: FileTypes.FileType = FileTypes.get_type_of_file(file_path)
			if file_type == FileTypes.FileType.UNKNOWN_FILE \
				or file_type == FileTypes.FileType.NON_EXISTING_FILE:
				file_name = dir.get_next()
				continue

			files[file_type] = files.get(file_type, []) + [file_path]

		file_name = dir.get_next()

	return files

## returns files with certain extensions[br]
## See [enum FileTypes.FileType]
func get_files_by_type(type: FileTypes.FileType) -> Array[String]:
	return _scan_files_in_directory("res://").get(type, [])
