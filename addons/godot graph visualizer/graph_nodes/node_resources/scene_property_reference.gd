@tool
extends Resource
class_name ScenePropertyReference

var _scene_instances: Dictionary[SceneData, int]
var _attached_script: ScriptData

#region Setters
func add_instance(instance: SceneData) -> void:
	_scene_instances[instance] = _scene_instances.get(instance, 0) + 1

func set_attached_script(attached_script: ScriptData) -> bool:
	if _attached_script:
		push_error("Error: Already attached a script \'%s\'" % _attached_script.get_node_name())
		return false

	_attached_script = attached_script
 
	return true
#endregion

#region Getters
func get_instance_with_path(path: String) -> SceneData:
	for scn: SceneData in _scene_instances:
		if scn.get_node_path() == path:
			return scn
	
	return null

func get_attached_script() -> ScriptData:
	return _attached_script

func get_properties() -> Dictionary:
	var instances_serialized: Dictionary[String, int] = {}
	for inst: SceneData in _scene_instances:
		instances_serialized.set(inst.get_node_path(), _scene_instances[inst])

	return {
		"attached_script": get_attached_script().serialize() if _attached_script else {},
		"instance": instances_serialized
	}
#endregion
