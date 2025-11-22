@tool
extends Resource
class_name ScriptPropertyReference

## Class made to save reference read of a script in [class ScriptPropertyManager][br]
## It saves variables, constants, methods and also, use variable scoping
## @experimental: methods and variable scoping are still under development, expect changes

## Holds the value of the class name of a script
var _class_name: String = ""
## Holds a dictionary with the variables of a script:[br]
## key: name, value: var value
var _script_vars: Dictionary[String, String] = {}

# TODO: Start working in method parsing and variable scoping

#region Add Property
## Adds a variable [param var_name] with its value [param value]
## to the [member _script_vars] dictionary if it doesnt exists
func add_var(var_name: String, value: String) -> bool:
	if _script_vars.has(var_name):
		push_error("Error: Already declarated property \'%s\'" % var_name)
		return false

	_script_vars[var_name] = value

	return true

## If [member _class_name] is equals to an empty string,
## Updates it with the entered [param c_name]
func set_class_name(c_name: String) -> bool:
	if _class_name != "":
		push_error("Error: Already declarated a class_name \'%s\'" % _class_name)
		return false

	_class_name = c_name

	return true
#endregion

#region Get Property
## Returns a variable with name [param v]
func get_var(v: String) -> String:
	return _script_vars.get(v, "")

## Returns [member _class_name]
func get_class_name() -> String:
	return _class_name

## Returns the entire dictionary [member _script_vars]
func get_vars() -> Dictionary[String, String]:
	return _script_vars

## Returns in a wrapped way:[br]
## [member _class_name], [member _script_vars] and [member _script_consts]
func get_properties() -> Dictionary:
	return {
		"class_name": get_class_name(),
		"var": _script_vars
	}
#endregion
