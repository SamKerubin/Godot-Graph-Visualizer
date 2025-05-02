@tool
extends Node
class_name ScriptScopeManager
# Fix this and the other managers
const CLASS_DECLARATION_REFERENCE: String = r"^class_name\s+(\w+)"
const VARIABLE_DECLARATION_REFERENCE: String = r"(var|const)\s+(\w+)(?::\s*\w+)?\s*:?=\s*(.+)"

var _script_references: Dictionary[String, ScriptScopeReference] = {}
var _class_regex: RegEx = RegEx.new()
var _variable_regex: RegEx = RegEx.new()

func _ready() -> void:
	_class_regex.compile(CLASS_DECLARATION_REFERENCE)
	_variable_regex.compile(VARIABLE_DECLARATION_REFERENCE)

func _on_line_reached(line: String, from_path: String) -> void:
	var var_match: RegExMatch = _variable_regex.search(line)
	if not var_match: return

	var type: String = var_match.get_string(1)
	var value_name: String = var_match.get_string(2)
	var value: String = var_match.get_string(3)

	var c_name: String = ""
	var class_match: RegExMatch = _class_regex.search(line)
	if class_match:
		c_name = class_match.get_string(1)

	var ref: ScriptScopeReference
	if _script_references.has(from_path):
		ref = _script_references[from_path]
	else:
		ref = ScriptScopeReference.new()
		_script_references[from_path] = ref

	if c_name != "":
		ref.set_class_name(c_name)

	if type == "var":
		ref.add_var(value_name, value)
	elif type == "const":
		ref.add_const(value_name, value)

func find_var_from(script: String, var_name: String) -> String:
	return _script_references[script].get_var(var_name)

func find_const_from(script: String, const_name: String) -> String:
	return _script_references[script].get_const(const_name)

func find_var_from_class(c_name: String, var_name: String) -> String:
	for r: ScriptScopeReference in _script_references.values():
		if r.get_class_name() == c_name:
			return r.get_var(var_name)
	return ""

func find_const_from_class(c_name: String, const_name: String) -> String:
	for r: ScriptScopeReference in _script_references.values():
		if r.get_class_name() == c_name:
			return r.get_const(const_name)
	return ""
