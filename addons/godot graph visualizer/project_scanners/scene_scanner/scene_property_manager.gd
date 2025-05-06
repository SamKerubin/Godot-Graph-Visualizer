@tool
extends FileReaderManager

signal initialize

const SCRIPT_REFERENCE: String = ""
const INSTANCE_REFERENCE: String = ""

const TEMP_FILE_PATH: String = "user://temp_file.tscn"

var _scene_properties: Array[SceneData]

var _script_regex: RegEx = RegEx.new()
var _instance_regex: RegEx = RegEx.new()

func _init() -> void:
	_script_regex.compile(SCRIPT_REFERENCE)
	_instance_regex.compile(INSTANCE_REFERENCE)

func _read_file(path: String) -> void:
	path = _parse_binary_file(path)
	if not path: return

	var scene: FileAccess = FileAccess.open(path, FileAccess.READ)
	if not scene:
		push_error("Error: Unable to open file \'%s\'" % path)
		return
	
	while scene.eof_reached():
		var line: String = scene.get_line()

	scene.close()

func _parse_binary_file(path: String) -> String:
	if path.get_extension() == "tscn": return path

	var binary_scene: PackedScene = ResourceLoader.load(path, "PackedScene")

	if ResourceSaver.save(binary_scene, TEMP_FILE_PATH, ResourceSaver.FLAG_CHANGE_PATH) != OK:
		push_error("Error: Unable to save file \'%s\' as a .tscn archive" % path)
		return ""

	return TEMP_FILE_PATH

func search_properties_in_all_scenes() -> void:
	var scenes: Array = FileScanner.get_files_by_type(FileTypes.FileType.SCENE_FILE)
	for scn: String in scenes:
		_read_file(scn)

	initialize.emit()

func get_scenes_properties() -> Array[SceneData]:
	return _scene_properties
