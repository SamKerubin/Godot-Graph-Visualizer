@tool
extends Node
##@experimental: This class is currently under development, stay tunned with the constants updates to see
## future changes 
class_name BaseGraphNode

@export var node_data: BaseGraphNodeResource = load("uid://hjjgap7tfq74").duplicate()

func show_data() -> void:
	print(node_data.get_node_name())
	print(node_data.get_node_path())
	print(node_data.get_uid_text())
	print(node_data.get_uid_int())
