@tool
extends Resource
class_name ScriptReferenceManager

var _script_properties: ScriptPropertiesManager
var _scripts: Array[ScriptData]

func _init() -> void:
	_script_properties = ScriptPropertiesManager.new()
	_scripts = []

func _get_script_content(path: String) -> String:
	var script: FileAccess = FileAccess.open(path, FileAccess.READ)
	if not script:
		push_error("Error: Unable to open '%s'" % path)
		return ""

	var content: String = script.get_as_text()
	script.close()
	return content

func find_script_with_path(path: String) -> ScriptData:
	for scr: ScriptData in _scripts:
		if scr.get_node_path() == path or scr.get_node_uid() == path:
			return scr

	return null

func build_all_references(script_paths: Array) -> void:
	_scripts.clear()
	var script_tokenizer: ScriptTokenizer = ScriptTokenizer.new()
	var script_parser: ScriptParser = ScriptParser.new()
	var reference_builder: ReferenceBuilder = ReferenceBuilder.new(_script_properties)

	for path: String in script_paths:
		var content: String = _get_script_content(path)
		if content.is_empty():
			continue

		var tokens: Array[AST.Token] = script_tokenizer.tokenize(content)
		var parsed_script: ScriptProperty = script_parser.parse_script(tokens)
		_script_properties.add_script_to_database(path, parsed_script)

	var script_properties: Dictionary[String, ScriptProperty] = _script_properties.get_all_scripts()
	for path: String in script_properties.keys():
		var property: ScriptProperty = script_properties[path]
		var script_reference: ScriptData = reference_builder.build_reference(path, property)
		_scripts.append(script_reference)
