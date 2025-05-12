@tool
extends Resource
class_name ScriptParsedReference

var script_data: ScriptData

var _load_reference: Dictionary[String, int] = {}
var _preload_reference: Dictionary[String, int] = {}
var _instance_refenrence: Dictionary[String, int] = {}

func add_load(path: String) -> void:
	_load_reference[path] = _load_reference.get(path, 0) + 1

func add_preload(path: String) -> void:
	_preload_reference[path] = _preload_reference.get(path, 0) + 1

func add_instance(path: String) -> void:
	_instance_refenrence[path] = _instance_refenrence.get(path, 0) + 1

func set_parsed_properties(properties: Dictionary) -> void:
	_load_reference = properties["load"].duplicate()
	_preload_reference = properties["preload"].duplicate()
	_instance_refenrence = properties["instance"].duplicate()

func get_parsed_properties() -> Dictionary:
	return {
		"load": _load_reference,
		"preload": _preload_reference,
		"instance": _instance_refenrence
	}
