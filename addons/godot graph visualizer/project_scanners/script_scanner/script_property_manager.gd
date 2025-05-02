@tool
extends FileReaderManager
class_name ScriptPropetyManager

signal files_read

const CLASS_DECLARATION_REFERENCE: String = r"^class_name\s+(\w+)"
const VARIABLE_DECLARATION_REFERENCE: String = \
	r"(var|const)\s+(\w+)(?::\s*(?:[\w.]+(?:\s*\[\s*[\w\s,]+\s*\])?))?\s*(?:(?::?=)\s*(.+))?"

var _script_properties: Dictionary[BaseGraphNodeResource, ScriptPropertyReference] = {}

var _class_regex: RegEx = RegEx.new()
var _variable_regex: RegEx = RegEx.new()

func _init() -> void:
	_class_regex.compile(CLASS_DECLARATION_REFERENCE)
	_variable_regex.compile(VARIABLE_DECLARATION_REFERENCE)

func _read_file(path: String) -> void:
	var script: FileAccess = FileAccess.open(path, FileAccess.READ)
	if not script:
		push_error("Error: Unable to open script \'%s\'" % path)
		return

	while not script.eof_reached():
		var line: String = script.get_line()
		if line:
			if line.begins_with("#"): continue

			var result: ScriptPropertyReference = _search_in_line(line, path)
			var graph_resource: BaseGraphNodeResource = _find_script_with_path(path)
			if result: _store_line(result, graph_resource)

	script.close()

func _search_in_line(line: String, path: String) -> ScriptPropertyReference:
	var c_name: String = ""
	var class_match: RegExMatch = _class_regex.search(line)
	if class_match: c_name = class_match.get_string(1)

	var type: String = ""
	var value_name: String = ""
	var value: String = ""

	var var_match: RegExMatch = _variable_regex.search(line)
	if var_match:
		type = var_match.get_string(1)
		value_name = var_match.get_string(2)
		value = var_match.get_string(3)

	var graph_resource: BaseGraphNodeResource = _find_script_with_path(path)

	var scope_reference: ScriptPropertyReference = ScriptPropertyReference.new() \
		if not _script_properties.has(graph_resource) \
		else  _script_properties[graph_resource]

	if c_name != "": scope_reference.set_class_name(c_name)

	if type == "var": scope_reference.add_var(value_name, value)
	elif type == "const": scope_reference.add_const(value_name, value)

	return scope_reference

func _store_line(scope_reference: ScriptPropertyReference, graph_resource: BaseGraphNodeResource) -> void:
	_script_properties[graph_resource] = scope_reference

func _find_script_with_path(path: String) -> BaseGraphNodeResource:
	for scr: BaseGraphNodeResource in _script_properties:
		if scr.get_node_path() == path or scr.get_uid_text() == path:
			return scr

	var new_resource = BaseGraphNodeResource.new(path)
	_script_properties[new_resource] = ScriptPropertyReference.new()

	return new_resource

func search_scopes_in_all_scripts() -> void:
	var scripts: Array = FileScanner.get_files_by_type(FileTypes.FileType.SCRIPT_FILE)
	for scr: String in scripts:
		_read_file(scr)

	files_read.emit()

func find_var_from(path: String, var_name: String) -> String:
	var script: BaseGraphNodeResource = _find_script_with_path(path)
	return _script_properties[script].get_var(var_name)

func find_const_from(path: String, const_name: String) -> String:
	var script: BaseGraphNodeResource = _find_script_with_path(path)
	return _script_properties[script].get_const(const_name)

func find_var_from_class(c_name: String, var_name: String) -> String:
	for r: ScriptPropertyReference in _script_properties.values():
		if r.get_class_name() == c_name:
			return r.get_var(var_name)

	return ""

func find_const_from_class(c_name: String, const_name: String) -> String:
	for r: ScriptPropertyReference in _script_properties.values():
		if r.get_class_name() == c_name:
			return r.get_const(const_name)

	return ""
