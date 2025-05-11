@tool
extends NodeData
##@experimental: This class is currently under development, stay tunned with the constants updates to see
## future changes 
class_name ScriptData

var _script_parsed_properties: ScriptParsedReference
var _active_scenes: Array[SceneData]

func _init(path_or_uid: String) -> void:
	_script_parsed_properties = ScriptParsedReference.new()
	super._init(path_or_uid)

func set_parsed_properties(parsed_properties: ScriptParsedReference) -> void:
	if _script_parsed_properties:
		push_error("Error: Already setted a parsed reference to script \'%s\'" % get_node_name())
		return

	_script_parsed_properties = parsed_properties

#region Getters
func get_parsed_properties() -> ScriptParsedReference:
	return _script_parsed_properties

func serialize() -> Dictionary:
	var script_data: Dictionary = super.serialize()
	script_data.merge(_script_parsed_properties.get_parsed_properties())

	return script_data
#endregion
