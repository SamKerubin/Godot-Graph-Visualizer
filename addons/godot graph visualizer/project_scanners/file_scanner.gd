@tool
extends Node

func scan_files_in_directory(path: String) -> Dictionary[String, Array]:
	var dir: DirAccess = DirAccess.open(path)
	
	var files: Dictionary[String, Array] = {}

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
			files.merge(scan_files_in_directory(file_path), true)
		else:
			var file_type: FileTypes.FileType = FileTypes.get_type_of_file(file_path)
			if files.has(file_type):
				files.get(file_type).append(file_path)
			else:
				files.set(file_type, [file_path])

		file_name = dir.get_next()

	return files
