@tool
extends Resource
class_name ScenePropertyReference

var _scene_instances: Array[SceneData]
var _attached_script: ScriptData

func add_instance(instance: SceneData) -> void:
	_scene_instances.append(instance)

func set_attached_script(attached_script: ScriptData) -> bool:
	if _attached_script:
		push_error("Error: Already attached a script \'%s\'" % _attached_script.get_node_name())
		return false

	_attached_script = attached_script

	return true

func get_instance_with_path(path: String) -> SceneData:
	for scn: SceneData in _scene_instances:
		if scn.get_node_path() == path or scn.get_uid_text() == path:
			return scn
	
	return null

func get_attached_script() -> ScriptData:
	return _attached_script

func get_properties() -> Dictionary:
	var instances_serialized: Array[Dictionary] = []
	for inst: SceneData in _scene_instances:
		instances_serialized.append(inst.serialize())

	return {
		"attached_script": get_attached_script().serialize() if get_attached_script() else {},
		"instance": instances_serialized
	}
