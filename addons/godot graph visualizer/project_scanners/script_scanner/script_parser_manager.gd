@tool
extends Resource
class_name ScriptParserManager

const SCENE_REFERENCE: String = \
	r"(?:(preload|load)\(\s*(\"(?:res|user|uid)://[^\"]*\"|[a-zA-Z_]\w*)\s*\)|" \
	+ r"([a-zA-Z_]\w*))(\.instantiate\(\)$)?"

var _scene_reference_regex: RegEx = RegEx.new()

var _parsed_scripts: Array[ScriptData]

var _script_properties: ScriptPropertyManager

func _init(script_files: Array) -> void:
	if _scene_reference_regex.compile(SCENE_REFERENCE) != OK:
		push_error("Error: Failed to compile scene reference regex")

	_script_properties = ScriptPropertyManager.new(script_files)

#region Script Parsing
func _parse_script(script_path: String, script_properties: ScriptPropertyReference) -> void:
	var script: ScriptData = ScriptData.new(script_path)
	var parsed_script: ScriptParsedReference = ScriptParsedReference.new()

	var script_vars: Dictionary[String, String] = script_properties.get_vars()
	var script_consts: Dictionary[String, String] = script_properties.get_consts()

	var missing_properties: Dictionary[String, String] = script_vars
	missing_properties.merge(script_consts)
	for property: String in missing_properties:
		var value: String = missing_properties[property]

		var matches: Array[String] = _match_property(value, script_properties)
		var type: String = matches[0]
		var path: String = matches[1]
		var instance: String = matches[2]

		if instance != "" and instance != "null":
			parsed_script.add_instance(path)

			continue

		if (type == "load" or type == "preload") and path != "null": parsed_script.add_packedscene(path)

	script.set_parsed_properties(parsed_script)
	_store_parsed_script(script)

func _store_parsed_script(script: ScriptData) -> void:
	if _parsed_scripts.has(script): return

	_parsed_scripts.append(script)

func _match_property(property: String, script: ScriptPropertyReference) -> Array[String]:
	var matches: RegExMatch = _scene_reference_regex.search(property)
	if not matches: return ["null", "null", "null"]

	var type: String = matches.get_string(1)
	var path: String = matches.get_string(2)
	var type_var: String = matches.get_string(3)
	var instance: String = matches.get_string(4)

	if path.begins_with("\"") and path.ends_with("\""):
		path = path.substr(1, path.length() - 2)

	if not type_var.is_empty() and type.is_empty():
		var resolved_value: String = _find_value(type_var, script)
		if resolved_value.is_empty(): return ["null", "null", "null"]

		var parts: PackedStringArray = resolved_value.split("\"")
		if parts.size() >= 2:
			path = parts[1]

	if not path.is_absolute_path() and not type.is_empty():
		path = _find_value(path, script)
	
	return [type, path, instance]

func _find_value(val: String, source: ScriptPropertyReference) -> String:
	var current_source: Variant = source
	var splitted_value: PackedStringArray = val.split(".")
	for v: int in range(splitted_value.size()):
		var actual_value: String = splitted_value[v]

		if current_source is ScriptPropertyReference:
			var current_var: String = current_source.get_var(actual_value)
			var current_const: String = current_source.get_const(actual_value)
			if not current_var.is_empty():
				var current_value: Variant = str_to_var(current_var)
				if not current_value:
					current_source = str(current_var)
				else:
					current_source = current_value

				continue

			elif not current_const.is_empty():
				var current_value: Variant = str_to_var(current_const)
				if not current_value:
					current_source = str(current_const)
				else:
					current_source = current_value

				continue

			current_source = _script_properties.find_script_property_with_class(actual_value)
			if not current_source:
				return ""

			continue

		elif current_source is Dictionary:
			current_source = current_source.get(actual_value, "")

		elif current_source is String:
			return current_source

		else: return ""

	return current_source if current_source is String else ""

func parse_all_scripts() -> void:
	_parsed_scripts.clear()
	_script_properties.search_properties_in_all_scripts()
	for scr: String in _script_properties.get_script_properties():
		_parse_script(scr, _script_properties.get_script_properties()[scr])
#endregion

func find_script_with_path(path: String) -> ScriptData:
	for scr: ScriptData in  _parsed_scripts:
		if scr.get_node_path() == path:
			return scr

	return null

func get_parsed_scripts() -> Array[ScriptData]:
	return _parsed_scripts

func get_script_properties() -> ScriptPropertyManager:
	return _script_properties
