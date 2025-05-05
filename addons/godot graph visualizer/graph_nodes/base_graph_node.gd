@tool
extends Node
##@experimental: This class is currently under development, stay tunned with the constants updates to see
## future changes 
class_name BaseGraphNode

@export var node_data: NodeData

func show_data() -> void:
	var data: Dictionary = node_data.serialize()
	for k: Variant in data:
		if typeof(data[k]) == TYPE_DICTIONARY:
			for v: String in data[k]:
				print("%s %s = %s" % [k, v, data[k][v]])
		else:
			print(k, ": ",data[k])
