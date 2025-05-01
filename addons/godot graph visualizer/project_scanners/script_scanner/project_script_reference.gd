@tool
extends Node
class_name ProjectScriptReferece

const VARIABLE_DECLARATION_REFERENCE: String = \
	r"(var|const)\s+(\w+)(?::\s*\w+)?\s*:?=\s*(.+)"

static var script_references: Dictionary[String, ScriptVariableReference] = {}


func _ready() -> void:
	ProjectScriptReader.line_reached.connect(_on_line_reached)

func _on_line_reached(line: String, from_path: String) -> void:
	var variable_regex: RegEx = RegEx.new()
	variable_regex.compile(VARIABLE_DECLARATION_REFERENCE)

	var matches: RegExMatch = variable_regex.search(line)
	if not matches: return

	var type: String = matches.get_string(1)
	var value_name: String = matches.get_string(2)
	var value: String = matches.get_string(3)

	if script_references.has(from_path):
		script_references[from_path].set_value(value_name, value, type)
	else:
		var new_script_reference = ScriptVariableReference.new()
		new_script_reference.set_value(value_name, value, type)
		script_references[from_path] = new_script_reference
	
