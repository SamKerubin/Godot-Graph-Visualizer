@tool
extends Panel

## @experimental: This class in still unfinished, expect changes and testing[br]
## Class made to handle every action inside the graph:
## node generation/interaction, layout generation

const _HOVER_SCENE: PackedScene = preload("uid://c8sm51cqoyt8k")

@onready var container := $Separator

@onready var graph := $Separator/Graph
@onready var click_info := $Separator/ClickInfo
@onready var close_click_interface := $Separator/ClickInfo/CloseClickInterface

var _file_scanner: FileScanner
var _scene_property_manager: ScenePropertyManager
var _relation_manager: RelationManager
var _node_filter: NodeFilter
var _layout_manager: LayoutManager

var _hover_instance: Control

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
	_relation_manager = RelationManager.new()

	_file_scanner.files = _file_scanner.scan_files_in_directory("res://")
	var script_files: Array = _file_scanner.get_files_by_type(FileTypes.FileType.SCRIPT_FILE)
	var scene_files: Array = _file_scanner.get_files_by_type(FileTypes.FileType.SCENE_FILE)

	_scene_property_manager.search_properties_in_all_scenes(script_files, scene_files)
	_node_filter.set_temporal_properties(_scene_property_manager)

	var scenes: Array[SceneData] = _scene_property_manager.get_scenes_properties()

	relations = _node_filter.filter_nodes_by_type(graph_type, scenes, 
							hide_tool_scripts, _relation_manager
						)

	_layout_manager.set_up_layout(relations, graph, hide_unrelated_nodes)

	graph.delete_loading_screen()

func _on_graph_node_loaded(node: SamGraphNode) -> void:
	node.node_clicked.connect(_on_node_clicked)
	node.node_hovered.connect(_on_node_hovered)
	node.node_unhovered.connect(_on_node_unhovered)

func _on_close_click_interface_pressed() -> void:
	click_info.visible = false
	close_click_interface.visible = false
	click_info.clear_current_node()

func _on_node_clicked(node_name: String) -> void:
	var node: RelationData = _relation_manager.find_relation_with_name(node_name)

	click_info.set_current_node(node)
	click_info.visible = true
	close_click_interface.visible = true

	# Show the nodes name
	# Show every references listed with its path and times referenced

	#current_node_name.text = node_name
#
	#current_node_name.visible = true
	#references.visible = true
	#close.visible = true
	#message.visible = false

# TODO: Add the hover timer
func _on_node_hovered(node_name: String) -> void:
	# Evaluate first the maximum hover time (arsund .5 - .8 seconds)
	# If its greater or equals than the maximum hover time, then
	# show an interface with the nodes name, and how many relations it have (overall)
	if _hover_instance: pass
	
	var scene: RelationData = _relation_manager.find_relation_with_name(node_name)
	var node: SamGraphNode = _layout_manager.mapped_nodes.get(scene)
	if not node:
		return

	_hover_instance = _HOVER_SCENE.instantiate()
	add_child(_hover_instance)

	var node_position: Vector2 = node.get_global_position()
	var parent_position: Vector2 = _hover_instance.get_parent().get_global_position()
	var extra_offset: Vector2 = Vector2(20, -20)
	var incoming: int = scene.incoming.size()
	var outgoing: int = scene.outgoing.size()

	_hover_instance.position = (node_position - parent_position) - extra_offset
	_hover_instance.initialize(incoming, outgoing)

func _on_node_unhovered() -> void:
	if not _hover_instance: pass

	_hover_instance.queue_free()
	_hover_instance = null

func change_graph_type(type: String) -> void:
	graph_type = type
