@tool
extends Control
## @experimental: This class is currently being used to perform tests

@onready var options: Panel = $HSplitContainer/Options
@onready var main_graph: Panel = $HSplitContainer/MainGraph

@onready var packed_scene: Button = %PackedScene
@onready var instance: Button = %Instance

@onready var close_option_menu: Button = $HSplitContainer/Options/CloseOptionMenu
@onready var open_option_menu: Button = $HSplitContainer/MainGraph/OpenOptionMenu

@onready var reload_graph: Button = $HSplitContainer/Options/VSplitContainer/Filters/Reload

@onready var tool_scripts: CheckBox = %ToolScripts
@onready var unrelated_nodes: CheckBox = %UnrelatedNodes

@onready var instance_nodes_color: ColorPickerButton = %InstanceNodesColor
@onready var packed_scene_nodes_color: ColorPickerButton = %PackedSceneNodesColor
@onready var instance_nodes_connection_color: ColorPickerButton = %InstanceNodesConnectionColor
@onready var packed_scene_nodes_connection_color: ColorPickerButton = %PackedSceneNodesConnectionColor

func load_instance() -> void:
	main_graph.create_resources()

func save() -> void: pass

func _on_graph_color_changed(color: Color) -> void:
	main_graph.set_ui_colors(
		instance_nodes_color.color,
		packed_scene_nodes_color.color,
		instance_nodes_connection_color.color,
		packed_scene_nodes_connection_color.color
	)
