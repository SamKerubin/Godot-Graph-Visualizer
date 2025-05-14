@tool
extends GraphNode

const SCENE_NODE_DATA: PackedScene = preload("uid://464nttqxsix3")
const SCENE_HOVER_DATA: PackedScene = preload("uid://njqdp8wnedqf")

var scene_data: SceneData

var preload_references: Dictionary
var load_references: Dictionary
var instance_references: Dictionary

var scene_node_data: Control
var scene_hover_data: Control

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_double_click():
		selected = false
		EditorInterface.open_scene_from_path(scene_data.get_node_path())
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		scene_node_data = SCENE_NODE_DATA.instantiate()
		add_child(scene_node_data)
		scene_node_data.position = get_global_mouse_position()

func _on_mouse_entered() -> void:
	pass # Apply some hover effects

func _on_mouse_exited() -> void:
	if scene_hover_data: scene_hover_data.queue_free()

func initialize(scene_data: SceneData) -> void:
	self.scene_data = scene_data

	title = scene_data.get_node_name().to_snake_case().replace("_", " ").capitalize()

	var serialized_data: Dictionary = scene_data.serialize()
	var script_serialized_data: Dictionary = serialized_data.get("attached_script", {})

	preload_references = script_serialized_data.get("preload", {})
	load_references = script_serialized_data.get("load", {})
	instance_references = script_serialized_data.get("instance", {})

	var scene_instances: Dictionary = serialized_data.get("instance", {})
	for inst: String in scene_instances:
		instance_references[inst] = instance_references.get(inst, 0) + scene_instances[inst]
