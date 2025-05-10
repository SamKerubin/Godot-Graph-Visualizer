@tool
extends Node

signal initialize

const SCENE_REFERENCE: String = "" # preload|load(path).instantiate() <-- instantiate as optional
const INSTANTIATE_REFERENCE: String = \
	r"(?:(?:load|preload)\(\s*\"(?:(?:uid|res)://[^\"]+)\"\s*\)|\b\w+)\.instantiate\(\)"

var _scene_reference_regex: RegEx = RegEx.new()

var _parsed_scripts: Array[ScriptParsedReference]

func _ready() -> void:
	_scene_reference_regex.compile(SCENE_REFERENCE)

#region Script Parsing
func _parse_script(script: ScriptData) -> void:
	var script_vars: Dictionary[String, String] = script.serialize()["var"]
	var script_consts: Dictionary[String, String] = script.serialize()["const"]

	var parsed_script: ScriptParsedReference = ScriptParsedReference.new()
	var missing_properties: Dictionary[String, String] = script_vars
	missing_properties.merge(script_consts)
	for property: String in missing_properties:
		var value: String = missing_properties[property]

		var matches: Array[String] = _match_property(value, script)
		var type: String = matches[0]
		var path: String = matches[1]
		var instance: String = matches[2]

		var scene: SceneData = ScenePropertyManager.find_scene_with_path(path)
		if not instance.is_empty():
			if not scene:
				push_error("Error: Unable to load scene \'%s\'" % path)
				return

			parsed_script.add_instance(scene)

			continue

		if type == "load": parsed_script.add_load(scene)
		elif type == "preload": parsed_script.add_preload(scene)

	_parsed_scripts.append(parsed_script)

func _match_property(property: String, script: ScriptData) -> Array[String]:
	var matches: RegExMatch = _scene_reference_regex.search(property)
	if not matches: return ["", "", ""]

	var type: String = matches.get_string(1)
	var path: String = matches.get_string(2)
	var instance: String = ""

	if matches.strings.size() > 3:
		instance = matches.get_string(3)

	if type != "load" or type != "preload":
		type = _find_value(type, script).get_slice("(", 0)

	if not path.is_absolute_path():
		path = _find_value(path, script)
	
	return [type, path, instance]

func _find_value(val: String, source: ScriptData) -> String:
	var current_source: Variant = source
	var splitted_value: PackedStringArray = val.split(".")
	for v: int in range(splitted_value.size()):
		var actual_value: String = splitted_value[v]

		if current_source is ScriptData:
			var current_var: String = current_source.get_properties().get_var(actual_value)
			var current_const: String = current_source.get_properties().get_const(actual_value)
			if not current_var.is_empty():
				current_source = str_to_var(current_var)
				continue

			elif not current_const.is_empty():
				current_source = str_to_var(current_const)
				continue

			current_source = ScriptPropertyManager.find_script_with_class(actual_value)
			if not current_source:
				push_error("Error: Unable to parse value \'%s\', value might not exist" % actual_value)
				return ""

			continue

		elif typeof(current_source) == TYPE_DICTIONARY:
			current_source = current_source.get(actual_value, "")

		elif typeof(current_source) == TYPE_STRING:
			return current_source

		else: return ""

	return current_source

func parse_all_scripts() -> void:
	var scripts: Array[ScriptData] = ScriptPropertyManager.get_scripts_properties()
	for scr in scripts:
		_parse_script(scr)

	initialize.emit()
#endregion

#region Get Script Reference
func get_parsed_scripts() -> Array[ScriptParsedReference]:
	return _parsed_scripts
#endregion
