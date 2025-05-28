@tool
extends Panel

@onready var graph: GraphEdit = $Graph

var _file_scanner: FileScanner
var _scene_property_manager: ScenePropertyManager

var instance_node_color: Color
var packedscene_node_color: Color
var instance_node_connection_color: Color
var packedscene_node_connection_color: Color

func _ready() -> void:
	_file_scanner = FileScanner.new()
	scan_project()

func scan_project() -> void:
	_file_scanner.files = _file_scanner.scan_files_in_directory("res://")
	var script_files: Array = _file_scanner.get_files_by_type(FileTypes.FileType.SCRIPT_FILE)
	var scene_files: Array = _file_scanner.get_files_by_type(FileTypes.FileType.SCENE_FILE)
	_scene_property_manager = ScenePropertyManager.new(script_files, scene_files)

	_scene_property_manager.search_properties_in_all_scenes()

func set_ui_colors(ins_n: Color, pck_n: Color, inst_cn: Color, pack_cn: Color) -> void:
	instance_node_color = ins_n
	packedscene_node_color = pck_n
	instance_node_connection_color = inst_cn
	packedscene_node_connection_color = pack_cn
