@tool
extends Control
## @experimental: This class is currently being used to perform tests

@onready var grid_container: GridContainer = $GridContainer


func _ready() -> void:
	create_nodes()

func _button_pressed(node: BaseGraphNode) -> void:
	node.show_data()
	print()

func create_nodes() -> void:
	for path: String in FileScanner.get_files_by_type(FileTypes.FileType.SCRIPT_FILE):
		var node = BaseGraphNode.new()
		node.node_data.initialize(path)
		var button: Button = Button.new()
		button.text = node.node_data.get_node_name()
		button.size = Vector2(100, 100)
		grid_container.add_child(button)
		button.pressed.connect(_button_pressed.bind(node))

func save() -> void: pass
