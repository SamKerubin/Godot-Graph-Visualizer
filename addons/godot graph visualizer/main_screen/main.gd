@tool
extends Control
## @experimental: This class is currently being used to perform tests

@onready var options: Panel = $VSplitContainer/HSplitContainer/Options
@onready var graph_info: Panel = $VSplitContainer/GraphInfo
@onready var close_option_menu: Button = $VSplitContainer/HSplitContainer/Options/CloseOptionMenu
@onready var open_option_menu: Button = $VSplitContainer/HSplitContainer/MainGraph/OpenOptionMenu

@onready var instance_nodes_color: ColorPickerButton = %InstanceNodesColor
@onready var packed_scene_nodes_color: ColorPickerButton = %PackedSceneNodesColor
@onready var instance_nodes_connection_color: ColorPickerButton = %InstanceNodesConnectionColor
@onready var packed_scene_nodes_connection_color: ColorPickerButton = %PackedSceneNodesConnectionColor

func _on_close_option_menu_pressed() -> void:
	options.visible = false
	graph_info.visible = false
	open_option_menu.visible = true

func _on_open_option_menu_pressed() -> void:
	options.visible = true
	graph_info.visible = true
	open_option_menu.visible = false

func save() -> void: pass
