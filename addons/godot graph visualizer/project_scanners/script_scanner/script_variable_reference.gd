@tool
extends Node
class_name ScriptVariableReference

var _script_vars: Dictionary[String, String]
var _script_consts: Dictionary[String, String]

func set_value(value_name: String, value: String, to: String) -> void:
	if _script_vars.has(value_name) or _script_consts.has(value_name):
		push_error("Error: value '%s' already declared." % value_name)
		return
	
	if to == "var":
		_script_vars[value_name] = value
	else:
		_script_consts[value_name] = value

func get_var(v: String) -> String:
	return _script_vars.get(v, "")

func get_const(c: String) -> String:
	return _script_consts.get(c, "")
