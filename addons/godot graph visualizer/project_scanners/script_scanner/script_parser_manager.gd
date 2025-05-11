@tool
extends Node

signal initialize

const SCENE_REFERENCE: String = \
	r"(?:(preload|load)\(\s*(\"(?:res|user|uid)://[^\"]*\"|[a-zA-Z_]\w*)\s*\)|([a-zA-Z_]\w*))(\.instantiate\(\))?"

var _scene_reference_regex: RegEx = RegEx.new()

var _parsed_scripts: Array[ScriptData]

var _script_properties: ScriptPropertyManager

func _ready() -> void:
	_script_properties = ScriptPropertyManager.new()
	_script_properties.property_created.connect(_on_property_created)
	_scene_reference_regex.compile(SCENE_REFERENCE)

#region Script Parsing
func _on_property_created(path: String, property: ScriptPropertyReference) -> void:
	var script_data: ScriptData = ScriptData.new(path)
	if _parsed_scripts.has(script_data): return

	_parsed_scripts.append(script_data)

func _parse_script(script_path: String) -> void:
	var script_properties: ScriptPropertyReference = _script_properties.get_script_properties()[script_path]
	var script: ScriptData = find_script_with_path(script_path)
	var parsed_script: ScriptParsedReference = ScriptParsedReference.new()

	var script_vars: Dictionary[String, String] = script_properties.get_vars()
	var script_consts: Dictionary[String, String] = script_properties.get_consts()

	var missing_properties: Dictionary[String, String] = script_vars
	missing_properties.merge(script_consts)
	for property: String in missing_properties:
		var value: String = missing_properties[property]

		var matches: Array[String] = _match_property(value, script)
		var type: String = matches[0]
		var path: String = matches[1]
		var instance: String = matches[2]

		if not instance.is_empty():

			parsed_script.add_instance(path)

			continue

		if type == "load": parsed_script.add_load(path)
		elif type == "preload": parsed_script.add_preload(path)

	script.set_parsed_properties(parsed_script)

func _match_property(property: String, script: ScriptData) -> Array[String]:
	var matches: RegExMatch = _scene_reference_regex.search(property)
	if not matches: return ["", "", ""]

	var type: String = matches.get_string(1)
	var path: String = matches.get_string(2)
	var type_var: String = matches.get_string(3)
	var instance: String = matches.get_string(4)

	if path.begins_with("\"") and path.ends_with("\""):
		path = path.substr(1, path.length() - 2)

	if not type_var.is_empty() and type.is_empty():
		type = type_var

		var resolved_value: String = _find_value(type_var, script)
		var parts: PackedStringArray = resolved_value.split("\"")
		if parts.size() >= 2:
			path = parts[1]

	if not path.is_absolute_path() and not type.is_empty():
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

			current_source = _script_properties.find_script_with_class(actual_value)
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
	_script_properties.search_properties_in_all_scripts()
	for scr: String in _script_properties.get_script_properties():
		_parse_script(scr)

	initialize.emit()
#endregion

func find_script_with_path(path: String) -> ScriptData:
	for scr: ScriptData in _parsed_scripts:
		if scr.get_node_path() == path or scr.get_uid_text() == path:
			return scr

	return null

func find_script_with_class(c_name: String) -> ScriptData:
	for scr: ScriptData in _parsed_scripts:
		if scr.get_properties().get_class_name() == c_name:
			return scr

	return null

func get_parsed_scripts() -> Array[ScriptData]:
	return _parsed_scripts

func get_script_properties() -> ScriptPropertyManager:
	return _script_properties
