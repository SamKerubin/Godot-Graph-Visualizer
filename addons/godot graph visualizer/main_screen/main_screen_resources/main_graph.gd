@tool
extends Panel

@onready var container: VSplitContainer = $VSplitContainer2

@onready var graph: GraphEdit = $VSplitContainer2/Graph

@onready var close: Button = $VSplitContainer2/GraphInfo/Close
@onready var message: Label = $VSplitContainer2/GraphInfo/Message

@onready var references: ItemList = $VSplitContainer2/GraphInfo/Container/References
@onready var current_node_name: Label = $VSplitContainer2/GraphInfo/Container/Node

var _file_scanner: FileScanner
var _scene_property_manager: ScenePropertyManager

var instance_node_color: Color
var packedscene_node_color: Color
var instance_node_connection_color: Color
var packedscene_node_connection_color: Color

var graph_type: String = "instance" # By default it will generate an instance graph

var relations: Array[Dictionary] = [] # Dictionary -> String, int

func _ready() -> void:
	graph.create_loading_screen()
	graph.node_loaded.connect(_on_graph_node_loaded)

	_file_scanner = FileScanner.new()
	_scene_property_manager = ScenePropertyManager.new()
	scan_project()

func _on_graph_node_loaded(node: SamGraphNode) -> void:
	node.node_clicked.connect(_on_node_clicked)
	node.node_hovered.connect(_on_node_hovered)
	node.node_unhovered.connect(_on_node_unhovered)

func _on_node_clicked(path: String, node_name: String) -> void:
	# Get references for node of path 'path'
	# If current graph its a instance graph, it must return
	# only instance references
	# If not, return preload/load references 
	
	""" 
		PSTD: add a value to the regex in ScriptParserManager
		So you can also allow the user to use ResourceLoader.load(path)
	"""
	pass

func _on_node_hovered(path: String, node_name: String) -> void:
	# Evaluate first the maximum hover time (around .5 - .8 seconds)
	# If its bigger or equals than the maximum hover time, then
	# show an interface with the nodes name, and how many relations it have (overall)
	pass
 
func _on_node_unhovered() -> void:
	# If exists, delete the hover interface
	pass

func scan_project() -> void:
	_file_scanner.files = _file_scanner.scan_files_in_directory("res://")
	var script_files: Array = _file_scanner.get_files_by_type(FileTypes.FileType.SCRIPT_FILE)
	var scene_files: Array = _file_scanner.get_files_by_type(FileTypes.FileType.SCENE_FILE)

	_scene_property_manager.search_properties_in_all_scenes(script_files, scene_files)
	#graph.set_nodes() <- Modify later

func set_ui_colors(ins_n: Color, pck_n: Color, inst_cn: Color, pack_cn: Color) -> void:
	instance_node_color = ins_n
	packedscene_node_color = pck_n
	instance_node_connection_color = inst_cn
	packedscene_node_connection_color = pack_cn
