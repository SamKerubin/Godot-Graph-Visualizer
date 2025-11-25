@tool
extends Resource
class_name ScriptProperty

const _BASE_PARENT: String = "RefCounted"

var _script_class: String
var _script_parent: String = _BASE_PARENT

func set_class_name(c_name: String) -> void:
	if _script_class.is_empty():
		_script_class = c_name

func set_parent(parent: String) -> void:
	if _script_parent == _BASE_PARENT:
		_script_parent = parent

func get_class_name() -> String:
	return _script_class

func get_parent() -> String:
	return _script_parent

# functions
#   |_ variables
#   |_ return values
# global variables
# assignments
