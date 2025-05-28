@tool
extends Resource
class_name FileScanner
## @experimental: This singleton may be up to changes
## [b]A class to scan files inside a godot project[/b][br]

var files: Dictionary[FileTypes.FileType, Array] = {}

func scan_files_in_directory(path: String) -> Dictionary[FileTypes.FileType, Array]:
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
			#var in_addon: bool = file_path.begins_with("res://addons")

			var sub_files: Dictionary[FileTypes.FileType, Array] = scan_files_in_directory(file_path)
			for sf: FileTypes.FileType in sub_files.keys():
				files[sf] = files.get(sf, []) + sub_files[sf]
		else:
			var file_type: FileTypes.FileType = FileTypes.get_type_of_file(file_path)
			if file_type == FileTypes.FileType.NON_EXISTING_FILE:
				file_name = dir.get_next()
				continue

			files[file_type] = files.get(file_type, []) + [file_path]

		file_name = dir.get_next()

	return files

## returns files with certain extensions[br]
## See [enum FileTypes.FileType]
func get_files_by_type(type: FileTypes.FileType) -> Array:
	return files.get(type, [])
