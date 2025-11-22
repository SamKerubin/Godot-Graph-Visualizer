@tool
extends Resource
class_name FileScanner
## [b]A class to scan files inside a godot project[/b][br]
## Usually used with "res://" and "user://" directories[br]
## Feel free to use it if you need to! :3[br][br]
## See: [method scan_files_in_directory]

## Holds every file inside the project
var files: Dictionary[FileTypes.FileType, Array] = {}

# TODO: add a boolean value 'addons' to the method
## Opens the directory with Diraccess and adds every file recursively[br]
## Depending on its extension, adds it to a certain key in the dictionary[br]
## Also, you can use argument 'addons' to exclude /addons/ directory[br]
## [param path] refers to the directory path
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

## Returns a certain type of file paths
func get_files_by_type(type: FileTypes.FileType) -> Array:
	return files.get(type, [])
