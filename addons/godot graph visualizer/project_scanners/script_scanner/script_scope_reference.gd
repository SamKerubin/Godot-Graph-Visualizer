@tool
extends Node
class_name ScriptScopeReference

var _class_name: String = ""
var _script_vars: Dictionary[String, String] = {}
var _script_consts: Dictionary[String, String] = {}

func add_var(var_name: String, value: String) -> bool:
	if _script_vars.has(var_name):
		push_error("Error: Already declarated \'%s\'" % var_name)
		return false

	_script_vars[var_name] = value

	return true

func add_const(const_name: String, value: String) -> bool:
	if _script_consts.has(const_name):
		push_error("Error: Already declarated \'%s\'" % const_name)
		return false
	_script_consts[const_name] = value
	return true

func set_class_name(c_name: String) -> bool:
	if _class_name != "":
		return false
	_class_name = c_name
	return true

func get_var(v: String) -> String:
	return _script_vars.get(v, "")

func get_const(c: String) -> String:
	return _script_consts.get(c, "")

func get_class_name() -> String:
	return _class_name
