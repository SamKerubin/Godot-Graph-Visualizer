@tool
extends NodeData
class_name ScriptData

## Class made to hold the information of a script[br]
## See [class ScriptParsedReference], [class ScriptParserManager], [class NodeData] 

var _script_parsed_properties: ScriptParsedReference

## Flag that indicates if the current script is a tool script
## For more information about tool scripts, see [annotation @GDScript.@tool]
var is_tool: bool = false

func _init(path_or_uid: String) -> void:
	"""
		Uses a path (or uid) to initialize the parent class NodeData
		
		Also, initialize the parsed properties to a new instance
	"""

	_script_parsed_properties = ScriptParsedReference.new()
	super._init(path_or_uid)

## Sets a new value to the script parsed references
func set_parsed_properties(parsed_properties: ScriptParsedReference) -> void:
	_script_parsed_properties = parsed_properties

#region Getters
## Returns the script parsed references setted[br]
## See [method set_parsed_properties], [class ScriptParsedReference]
func get_parsed_properties() -> ScriptParsedReference:
	return _script_parsed_properties

## Returns a dictionary holding the information of the script[br]
## See [class NodeData] to understand which things are serialized
func serialize() -> Dictionary:
	var script_data: Dictionary = super.serialize()
	script_data.merge(_script_parsed_properties.get_parsed_properties())
	script_data.merge({"is_tool": is_tool})

	return script_data
#endregion
