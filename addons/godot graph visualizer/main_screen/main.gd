@tool
extends Control
## @experimental: This class is uncomplete, expect changes and some testing

@onready var options: Panel = $HSplitContainer/Options
@onready var main_graph: Panel = $HSplitContainer/MainGraph

@onready var packed_scene: Button = %PackedScene
@onready var instance: Button = %Instance

@onready var close_option_menu: Button = $HSplitContainer/Options/CloseOptionMenu
@onready var open_option_menu: Button = $HSplitContainer/MainGraph/OpenOptionMenu

@onready var reload_graph: Button = $HSplitContainer/Options/VSplitContainer/Filters/Reload

@onready var tool_scripts: CheckBox = %ToolScripts
@onready var unrelated_nodes: CheckBox = %UnrelatedNodes

var hide_tool_scripts: bool = false
var hide_unrelated_nodes: bool = false

func _ready() -> void:
	close_option_menu.pressed.connect(_option_menu_request.bind(false))
	open_option_menu.pressed.connect(_option_menu_request.bind(true))

	instance.pressed.connect(main_graph.change_graph_type.bind(instance.name.to_lower()))
	packed_scene.pressed.connect(main_graph.change_graph_type.bind(packed_scene.name.to_lower()))

func load_instance() -> void:
	main_graph.create_resources(hide_tool_scripts, hide_unrelated_nodes)

func _on_reload_graph_request() -> void:
	load_instance()

func _option_menu_request(opened: bool) -> void:
	options.visible = opened
	open_option_menu.visible = not opened

func _change_view_of_tool_scripts(toggled_on: bool) -> void:
	hide_tool_scripts = toggled_on

func _change_view_of_unrelated_nodes(toggled_on: bool) -> void:
	hide_unrelated_nodes = toggled_on
