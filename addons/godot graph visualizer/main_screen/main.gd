@tool
extends Control
## @experimental: This class is currently being used to perform tests

@onready var grid_container: GridContainer = $GridContainer

func _button_pressed(node: BaseGraphNode) -> void:
	node.show_data()

func _on_script_manager_initialized() -> void:
	create_script_nodes()

func _on_scene_manager_initialized() -> void:
	create_scene_nodes()

func create_script_nodes() -> void:
	for res: ScriptData in ScriptPropertyManager.get_scripts_properties():
		var node = ScriptGraphNode.new()
		node.node_data = res
		var button: Button = Button.new()
		button.text = node.node_data.get_node_name().to_pascal_case()
		button.size = Vector2(100, 100)
		grid_container.add_child(button)
		button.pressed.connect(_button_pressed.bind(node))

func create_scene_nodes() -> void: pass

func save() -> void: pass
