@tool
extends Node
class_name BaseGraphNode

@export var node_data: BaseGraphNodeResource = load("uid://hjjgap7tfq74").duplicate()

func show_data() -> void:
	print(node_data.get_node_name())
	print(node_data.get_node_path())
	print(node_data.get_uid_text())
	print(node_data.get_uid_int())
