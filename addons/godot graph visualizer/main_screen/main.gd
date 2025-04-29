@tool
extends Control

func _ready() -> void:
	var node = BaseGraphNode.new()
	var path: String = "res://addons/godot graph visualizer/main_screen/Main.tscn"
	node.node_data.initialize(path)
	node.show_data()

func save() -> void: pass
