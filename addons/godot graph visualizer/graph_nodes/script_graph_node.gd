@tool
extends BaseGraphNode
##@experimental: This class is currently under development, stay tunned with the constants updates to see
## future changes 
class_name ScriptGraphNode

func show_data() -> void:
	print(JSON.stringify(node_data.serialize(), "\t"))
