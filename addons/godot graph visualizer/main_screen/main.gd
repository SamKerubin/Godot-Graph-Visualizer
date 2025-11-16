@tool
extends Control
## @experimental: This class is uncomplete, expect changes and some testing

@onready var options: PanelContainer = $PanelContainer
@onready var main_graph: Panel = $MainGraph

@onready var packed_scene: Button = %PackedScene
@onready var instance: Button = %Instance

@onready var close_option_menu: Button = $ButtonMenu/CloseOptionMenu
@onready var open_option_menu: Button = $ButtonMenu/OpenOptionMenu

@onready var separator: MarginContainer = $MainGraph/Separator

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
	close_option_menu.visible = opened
	open_option_menu.visible = not opened

	var margin_if_closed: int = 0
	var margin_if_opened: int = 460
	var margin: int = margin_if_closed if not opened else margin_if_opened
	separator.add_theme_constant_override("margin_left", margin)

func _change_view_of_tool_scripts(toggled_on: bool) -> void:
	hide_tool_scripts = toggled_on

func _change_view_of_unrelated_nodes(toggled_on: bool) -> void:
	hide_unrelated_nodes = toggled_on
