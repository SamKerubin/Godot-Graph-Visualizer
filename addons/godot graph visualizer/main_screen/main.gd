@tool
extends Control
## @experimental: This class is currently being used to perform tests

@onready var grid_container: GridContainer = $GridContainer

func _enter_tree() -> void:
	GlobalPropertyManager.managers_initialized.connect(_on_managers_initialized)
	GlobalPropertyManager.initialize_all_scopes()

func _button_pressed(node: BaseGraphNode) -> void:
	node.show_data()

func _on_managers_initialized() -> void:
	create_nodes()

func create_nodes() -> void:
	for res: BaseGraphNodeResource in GlobalPropertyManager.script_property_manager._script_properties:
		var node = BaseGraphNode.new()
		node.node_data = res
		node.node_property = GlobalPropertyManager.script_property_manager._script_properties[res]
		var button: Button = Button.new()
		button.text = node.node_data.get_node_name()
		button.size = Vector2(100, 100)
		grid_container.add_child(button)
		button.pressed.connect(_button_pressed.bind(node))

func save() -> void: pass
