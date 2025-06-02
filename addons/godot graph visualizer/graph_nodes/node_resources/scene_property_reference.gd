@tool
extends Resource
class_name ScenePropertyReference

var _scene_instances: Dictionary[String, int]
var _attached_script: ScriptData

#region Setters
func add_instance(instance: String) -> void:
	_scene_instances[instance] = _scene_instances.get(instance, 0) + 1

func set_attached_script(attached_script: ScriptData) -> bool:
	if _attached_script:
		push_error("Error: Already attached a script \'%s\'" % _attached_script.get_node_name())
		return false

	_attached_script = attached_script
 
	return true
#endregion

#region Getters
func get_attached_script() -> ScriptData:
	return _attached_script

func get_properties() -> Dictionary:
	return {
		"attached_script": get_attached_script().serialize() if _attached_script else {},
		"instance": _scene_instances
	}
#endregion
