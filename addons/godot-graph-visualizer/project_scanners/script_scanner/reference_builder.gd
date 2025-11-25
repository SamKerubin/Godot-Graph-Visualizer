@tool
extends Resource
class_name ReferenceBuilder

var _script_properties_manager: ScriptPropertiesManager

func _init(script_properties_manager: ScriptPropertiesManager) -> void:
	self._script_properties_manager = script_properties_manager

func build_reference(path: String, property: ScriptProperty) -> ScriptData:
	return ScriptData.new(path)
