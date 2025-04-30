@tool
extends Control

@onready var button: Button = $HSplitContainer/Button

func _ready() -> void:
	var node = BaseGraphNode.new()
	var path: String = "res://addons/godot graph visualizer/main_screen/Main.tscn"
	node.node_data.initialize(path)
	button.pressed.connect(_button_pressed.bind(node))

func _button_pressed(node: BaseGraphNode) -> void:
	#node.show_data()
	print(FileScanner.get_files_by_type(FileTypes.FileType.SCRIPT_FILE))

func save() -> void: pass
