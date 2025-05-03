@tool
extends Node
##@experimental: This class is currently under development, stay tunned with the constants updates to see
## future changes 
class_name BaseGraphNode

@export var node_data: BaseGraphNodeResource
@export var node_property: ScriptPropertyReference

func show_data() -> void:
	print(node_data.get_node_name())
	print(node_data.get_node_path())
	print(node_data.get_uid_text())
	print(node_data.get_uid_int())
	
	for k: String in node_property._script_vars:
		var value: String = node_property.get_var(k)
		print("var %s = %s" % [k, value if value != "" else "null"])

	for k: String in node_property._script_consts:
		var value: String = node_property.get_const(k)
		print("const %s = %s" % [k, value if value != "" else "null"])
