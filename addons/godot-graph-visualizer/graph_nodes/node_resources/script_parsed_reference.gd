@tool
extends Resource
class_name ScriptParsedReference

# NOTE: deprecated class

## Class that holds every parsed reference from a script[br]
## See [class ScriptParserManager] to know more about references

## Saves the instance references and the times referenced
var _instance_reference: Dictionary[String, int] = {}
## Saves the packedscene references and the times referenced
var _packedscene_reference: Dictionary[String, int] = {}

## Adds a new reference if dont exists[br]
## If exists, then increment its time references by 1
func add_packedscene(path: String) -> void:
	_packedscene_reference[path] = _packedscene_reference.get(path, 0) + 1

## Adds a new reference if dont exists[br]
## If exists, then increment its time references by 1
func add_instance(path: String) -> void:
	_instance_reference[path] = _instance_reference.get(path, 0) + 1

## Sets news values to [member _instance_reference] and
## [member _packedscene_reference]
func set_parsed_properties(properties: Dictionary) -> void:
	_instance_reference = properties["instance"].duplicate()
	_packedscene_reference = properties["packedscene"].duplicate()

## Returns [member _instance_reference] and
## [member _packedscene_reference]
func get_parsed_properties() -> Dictionary:
	return {
		"packedscene": _packedscene_reference,
		"instance": _instance_reference
	}
