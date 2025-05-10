@tool
extends NodeData
##@experimental: This class is currently under development, stay tunned with the constants updates to see
## future changes 
class_name ScriptData

var _script_properties: ScriptPropertyReference
var _active_scenes: Array[SceneData]

func _init(path_or_uid: String) -> void:
	_script_properties = ScriptPropertyReference.new()
	super._init(path_or_uid)

#region Getters
func get_properties() -> ScriptPropertyReference:
	return _script_properties

func serialize() -> Dictionary:
	var script_data: Dictionary = super.serialize()
	script_data.merge(_script_properties.get_properties())

	return script_data
#endregion
