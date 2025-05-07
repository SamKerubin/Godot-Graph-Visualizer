@tool
extends Node

signal initialize

const CLASS_DECLARATION_REFERENCE: String = r"^class_name\s+(\w+)"
const VARIABLE_DECLARATION_REFERENCE: String = \
	r"(var|const)\s+(\w+)(?::\s*(?:[\w.]+(?:\s*\[\s*[\w\s,]+\s*\])?))?\s*(?:(?::?=)\s*(.+))?"

var _script_properties: Array[ScriptData]

var _class_regex: RegEx = RegEx.new()
var _variable_regex: RegEx = RegEx.new()

func _init() -> void:
	_class_regex.compile(CLASS_DECLARATION_REFERENCE)
	_variable_regex.compile(VARIABLE_DECLARATION_REFERENCE)

func _read_file(path: String) -> void:
	if not ResourceLoader.exists(path):
		push_error("Error: Invalid path \'%s\'" % path)
		return

	var script: FileAccess = FileAccess.open(path, FileAccess.READ)
	if not script:
		push_error("Error: Unable to open script \'%s\'" % path)
		return

	while not script.eof_reached():
		var line: String = script.get_line()
		if line:
			if line.begins_with("#"): continue

			var result: ScriptData = _search_in_line(line, path)
			
			if result: _store_line(result)

	script.close()

func _search_in_line(line: String, path: String) -> ScriptData:
	var c_name: String = _match_class(line)
	
	var property_match: Array[String] = _match_property(line)
	var type: String = property_match[0]
	var value_name: String = property_match[1]
	var value: String = property_match[2]

	var script_data: ScriptData = find_script_with_path(path)
	if not script_data: script_data = ScriptData.new(path)

	if c_name != "": script_data.get_properties().set_class_name(c_name)

	if type == "var": script_data.get_properties().add_var(value_name, value)
	elif type == "const": script_data.get_properties().add_const(value_name, value)

	return script_data

func _store_line(script: ScriptData) -> void:
	if _script_properties.has(script): return

	_script_properties.append(script)

func _match_class(line: String) -> String:
	var matches: RegExMatch = _class_regex.search(line)
	if matches: return matches.get_string(1)

	return ""

func _match_property(line: String) -> Array[String]:
	var matches: RegExMatch = _variable_regex.search(line)
	if matches: 
		return [
			matches.get_string(1), 
			matches.get_string(2), 
			matches.get_string(3)
		]

	return ["", "", ""]

func search_properties_in_all_scripts() -> void:
	var scripts: Array = FileScanner.get_files_by_type(FileTypes.FileType.SCRIPT_FILE)
	for scr: String in scripts:
		_read_file(scr)

	initialize.emit()

func find_script_with_path(path: String) -> ScriptData:
	for scr: ScriptData in _script_properties:
		if scr.get_node_path() == path or scr.get_uid_text() == path:
			return scr

	return null

func find_script_with_class(c_name: String) -> ScriptData:
	for scr: ScriptData in _script_properties:
		if scr.get_node_path() == c_name:
			return scr

	return null

func find_var_from(path: String, var_name: String) -> String:
	var script: ScriptData = find_script_with_path(path)
	if not script: return ""

	return script.get_properties().get_var(var_name)

func find_const_from(path: String, const_name: String) -> String:
	var script: ScriptData = find_script_with_path(path)
	if not script: return ""

	return script.get_properties().get_const(const_name)

func find_var_from_class(c_name: String, var_name: String) -> String:
	for v: ScriptData in _script_properties:
		if v.get_properties().get_class_name() == c_name:
			return v.get_var(var_name)

	return ""

func find_const_from_class(c_name: String, const_name: String) -> String:
	for c: ScriptData in _script_properties:
		if c.get_properties().get_class_name() == c_name:
			return c.get_const(const_name)

	return ""

func get_scripts_properties() -> Array[ScriptData]:
	return _script_properties
