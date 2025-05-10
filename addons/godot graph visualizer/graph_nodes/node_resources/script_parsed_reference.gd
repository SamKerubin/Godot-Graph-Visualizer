@tool
extends Resource
class_name ScriptParsedReference

var script_data: ScriptData

var _load_reference: Dictionary[SceneData, int]
var _preload_reference: Dictionary[SceneData, int]
var _instance_refenrence: Dictionary[SceneData, int]

func add_load(scene: SceneData) -> void:
	_load_reference[scene] = _load_reference.get(scene, 0) + 1

func add_preload(scene: SceneData) -> void:
	_preload_reference[scene] = _load_reference.get(scene, 0) + 1

func add_instance(scene: SceneData) -> void:
	_instance_refenrence[scene] = _instance_refenrence.get(scene, 0) + 1

func get_parsed_properties() -> Dictionary:
	var load_serialized: Dictionary[String, int] = {}
	var preload_serialized: Dictionary[String, int] = {}
	var instance_serialized: Dictionary[String, int] = {}

	for scn: SceneData in _load_reference:
		load_serialized.set(scn.get_node_path(), _load_reference[scn])

	return {
		"load": load_serialized,
		"preload": preload_serialized,
		"instance": instance_serialized
	}
