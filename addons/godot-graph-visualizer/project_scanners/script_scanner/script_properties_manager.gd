@tool
extends Resource
class_name ScriptPropertiesManager

var _script_properties: Dictionary[String, ScriptProperty]
var _script_properties_by_class_name: Dictionary[String, ScriptProperty]

func add_script_to_database(path: String, script_property: ScriptProperty) -> void:
	_script_properties.set(path, script_property)
	_script_properties_by_class_name.set(script_property.get_class_name(), script_property)

func get_script_with_path(path: String) -> ScriptProperty:
	return _script_properties.get(path, null)

func get_script_with_class_name(c_name: String) -> ScriptProperty:
	return _script_properties_by_class_name.get(c_name, null)

func get_all_scripts() -> Dictionary[String, ScriptProperty]:
	return _script_properties
