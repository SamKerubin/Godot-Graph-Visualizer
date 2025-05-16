@tool
extends Resource
## [b] A class made to hold the different godot native file extensions [/b][br]
## Use [method get_type_if_file] to get the type of any file in your project[br]
## @experimental: This class may be up to changes
class_name FileTypes

## Enum that holds the different types of godot's native project files
enum FileType {
	## Reference to a scene file
	SCENE_FILE,
	## Reference to a script file
	SCRIPT_FILE,
	## Reference to a resource file
	RESOURCE_FILE,
	## Reference to a unknown file
	UNKNOWN_FILE,
	## Reference to a file that does not exist
	NON_EXISTING_FILE
}

## Given the path of a file, returns the type of it
static func get_type_of_file(file_path: String) -> FileType:
	if not ResourceLoader.exists(file_path): return FileType.NON_EXISTING_FILE
	
	var file_extension = file_path.to_lower().get_extension()
	
	if file_extension == "tscn" or file_extension == "scn":
		return FileType.SCENE_FILE

	if file_extension == "gd" or file_extension == "cs":
		return FileType.SCRIPT_FILE

	if file_extension == "tres" or file_extension == "res":
		return FileType.RESOURCE_FILE

	return FileType.UNKNOWN_FILE
