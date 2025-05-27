@tool
extends Resource
class_name ScriptParsedReference

var script_data: ScriptData

var _instance_reference: Dictionary[String, int] = {}
var _packedscene_reference: Dictionary[String, int] = {}

func add_packedscene(path: String) -> void:
	_packedscene_reference[path] = _packedscene_reference.get(path, 0) + 1

func add_instance(path: String) -> void:
	_instance_reference[path] = _instance_reference.get(path, 0) + 1

func set_parsed_properties(properties: Dictionary) -> void:
	_instance_reference = properties["instance"].duplicate()
	_packedscene_reference = properties["packedscene"].duplicate()

func get_parsed_properties() -> Dictionary:
	return {
		"packedscene": _packedscene_reference,
		"instance": _instance_reference
	}
