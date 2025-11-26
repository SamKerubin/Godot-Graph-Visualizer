@tool
extends Resource
class_name ScriptProperty

class Variable:
	var name: String
	var assignments: Array[Assignment]
	var line: int

class Assignment:
	var value: String
	var line: int

class Scope:
	var name: String
	var variables: Array[Variable]
	var local_scope: Array[Scope]
	var parent: Scope
	var line: int

	func _init(name: String, variables: Array[Variable],
							local_scope: Array[Scope],
							parent: Scope,
							line: int) -> void:
		self.name = name
		self.variables = variables
		self.local_scope = local_scope
		self.parent = parent
		self.line = line

class FunctionScope extends Scope:
	var params: Scope
	var return_values: Array[Variable]

	func _init(name: String, variables: Array[Variable], 
							assigments: Array[Assignment], 
							local_scope: Array[Scope],
							parent: Scope,
							line: int,
							params: Scope,
							return_values: Array[Variable]) -> void:
		super._init(name, variables, local_scope, parent, line)
		self.params = params
		self.return_values = return_values

const _BASE_PARENT: String = "Object"

var _script_class: String
var _script_parent: String = _BASE_PARENT
var _global_scope: Scope

func set_class_name(c_name: String) -> void:
	if _script_class.is_empty():
		_script_class = c_name

func set_parent(parent: String) -> void:
	if _script_parent == _BASE_PARENT:
		_script_parent = parent

func set_global_scope(scope: Scope) -> void:
	_global_scope = scope

func get_class_name() -> String:
	return _script_class

func get_parent() -> String:
	return _script_parent

func get_global_scope() -> Scope:
	return _global_scope
