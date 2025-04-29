@tool
extends Node
class_name FileTypes

enum FileType {
	SCENE_FILE,
	SCRIPT_FILE,
	RESOURCE_FILE,
	UNKNOWN_FILE
}

static func get_type_of_file(file_path: String) -> FileType:
	file_path = file_path.to_lower()

	if file_path.ends_with(".tscn") or file_path.ends_with(".scn"):
		return FileType.SCENE_FILE

	if file_path.ends_with(".gd") or file_path.ends_with(".cs"):
		return FileType.SCRIPT_FILE

	if file_path.ends_with(".tres") or file_path.ends_with(".res"):
		return FileType.RESOURCE_FILE

	return FileType.UNKNOWN_FILE
