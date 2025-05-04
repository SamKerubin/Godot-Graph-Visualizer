@tool
extends Control
## @experimental: This class is currently being used to perform tests

@onready var grid_container: GridContainer = $GridContainer

# Hiii, if you are reading this, i may be taking a break
# I will be back very soon, dont worry... I just need to make a great plan for what is coming now
# For now... See ya! :3

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
		button.text = node.node_data.get_node_name().to_pascal_case()
		button.size = Vector2(100, 100)
		grid_container.add_child(button)
		button.pressed.connect(_button_pressed.bind(node))

func save() -> void: pass
