@tool
extends NodeData
class_name ScriptData

## Class made to hold the information of a script[br]
## See [class ScriptReference], [class ScriptParserManager], [class NodeData] 

var _script_references: ScriptReference

## Flag that indicates if the current script is a tool script
## For more information about tool scripts, see [annotation @GDScript.@tool]
var is_tool: bool = false

func _init(path_or_uid: String) -> void:
	"""
		Uses a path (or uid) to initialize the parent class NodeData
	"""

	_script_references = ScriptReference.new()
	super._init(path_or_uid)

func set_references(references: ScriptReference) -> void:
	_script_references = references

#region Getters

## Returns a dictionary holding the information of the script[br]
## See [class NodeData] to understand which things are serialized
func serialize() -> Dictionary:
	var script_data: Dictionary = super.serialize()
	script_data.merge(_script_references.serialize())
	script_data.merge({"is_tool": is_tool})

	return script_data
#endregion
