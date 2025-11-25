@tool
extends Resource
class_name ScriptReference

var _packedscene_references: Dictionary[String, Dictionary]
var _instance_references: Dictionary[String, Dictionary]
var _unresolved_references: Dictionary[String, int]

func serialize() -> Dictionary:
	return {
		"packedscene": _packedscene_references,
		"instance": _instance_references,
		"unresolved": _unresolved_references
	}
