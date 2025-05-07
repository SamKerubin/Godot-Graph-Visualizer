@tool
extends Node
##@experimental: This class is currently under development, stay tunned with the constants updates to see
## future changes 
class_name BaseGraphNode

@export var node_data: NodeData

func show_data() -> void:
	var data: Dictionary = node_data.serialize()
	for k: Variant in data:
		print("%s: %s" , [k, data[k]])
