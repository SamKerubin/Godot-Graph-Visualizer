@tool
extends BaseGraphNode
##@experimental: This class is currently under development, stay tunned with the constants updates to see
## future changes 
class_name ScriptGraphNode

func show_data() -> void:
	var data: Dictionary = node_data.serialize()
	for k: String in data:
		print(k , ": ", data[k])
