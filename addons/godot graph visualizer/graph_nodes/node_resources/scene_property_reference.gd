@tool
extends Resource
class_name ScenePropertyReference

var _scene_instances: Array[SceneData]
var _attached_script: ScriptData

"""

[ext_resource type="PackedScene"] -----> Scene instance

[ext_resource type="Script"] -----> Attached Script

"""

func add_instance(instance: SceneData) -> void:
	_scene_instances.append(instance)

func get_instance_with_path(path: String) -> SceneData:
	for scn: SceneData in _scene_instances:
		if scn.get_node_path() == path or scn.get_uid_text() == path:
			return scn
	
	return null

func get_attached_script() -> ScriptData:
	return _attached_script

func get_properties() -> Dictionary:
	return {
		"attached_script": get_attached_script(),
		"instances": _scene_instances
	}
