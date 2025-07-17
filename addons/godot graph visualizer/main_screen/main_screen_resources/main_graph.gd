@tool
extends Panel

## @experimental: This class in still unfinished, expect changes and testing[br]
## Class made to handle every action inside the graph:
## node generation/interaction, layout generation

@onready var container: VSplitContainer = $VSplitContainer2

@onready var graph: GraphEdit = $VSplitContainer2/Graph

@onready var close: Button = $VSplitContainer2/GraphInfo/Close
@onready var message: Label = $VSplitContainer2/GraphInfo/Message

@onready var references: ItemList = $VSplitContainer2/GraphInfo/Container/References
@onready var current_node_name: Label = $VSplitContainer2/GraphInfo/Container/Node

var _file_scanner: FileScanner
var _scene_property_manager: ScenePropertyManager
var _node_filter: NodeFilter
var _layout_manager: LayoutManager

var instance_node_color: Color
var packedscene_node_color: Color
var instance_node_connection_color: Color
var packedscene_node_connection_color: Color

var graph_type: String = "instance" # By default it will generate an instance graph

var relations: Array[RelationData] = []

func create_resources(hide_tool_scripts: bool, hide_unrelated_nodes: bool) -> void:
	graph.clear_graph()
	graph.create_loading_screen()

	_file_scanner = FileScanner.new()
	_scene_property_manager = ScenePropertyManager.new()
	_node_filter = NodeFilter.new()

	_layout_manager = LayoutManager.new()
	_layout_manager.node_loaded.connect(_on_graph_node_loaded)
	
	_layout_manager.layout_loaded.connect(graph._on_layout_loaded)

	scan_project(hide_tool_scripts, hide_unrelated_nodes)

func scan_project(hide_tool_scripts: bool, hide_unrelated_nodes: bool) -> void:
	_file_scanner.files = _file_scanner.scan_files_in_directory("res://")
	var script_files: Array = _file_scanner.get_files_by_type(FileTypes.FileType.SCRIPT_FILE)
	var scene_files: Array = _file_scanner.get_files_by_type(FileTypes.FileType.SCENE_FILE)

	_scene_property_manager.search_properties_in_all_scenes(script_files, scene_files)
	_node_filter.set_temporal_properties(_scene_property_manager)

	var scenes: Array[SceneData] = _scene_property_manager.get_scenes_properties()

	relations = _node_filter.filter_nodes_by_type(graph_type, scenes, hide_tool_scripts)

	_layout_manager.set_up_layout(relations, graph, hide_unrelated_nodes)

	graph.delete_loading_screen()

func set_ui_colors(ins_n: Color, pck_n: Color, inst_cn: Color, pack_cn: Color) -> void:
	instance_node_color = ins_n
	packedscene_node_color = pck_n
	instance_node_connection_color = inst_cn
	packedscene_node_connection_color = pack_cn

func _get_current_node_color() -> Color:
	return instance_node_color

func _get_current_connection_color() -> Color:
	return instance_node_connection_color

func change_graph_type(type: String) -> void:
	graph_type = type

func _on_graph_node_loaded(node: SamGraphNode) -> void:
	node.node_clicked.connect(_on_node_clicked)
	node.node_hovered.connect(_on_node_hovered)
	node.node_unhovered.connect(_on_node_unhovered)

func _on_node_clicked(path: String, node_name: String) -> void:
	# Get references for node of path 'path'
	# Show the nodes name
	# Show every references listed with its path and times referenced
	# Also, show the icon of the referenced scene
	pass

func _on_node_hovered(path: String, node_name: String) -> void:
	# Evaluate first the maximum hover time (around .5 - .8 seconds)
	# If its bigger or equals than the maximum hover time, then
	# show an interface with the nodes name, and how many relations it have (overall)
	pass

func _on_node_unhovered() -> void:
	# If exists, delete the hover interface
	pass
