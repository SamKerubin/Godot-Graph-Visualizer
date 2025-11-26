@tool
extends Resource
class_name AST

class Token:
	var type: int
	var value: String

	func _init(type: int, value: String) -> void:
		self.type = type
		self.value = value

class ASTNode:
	var type: int

	func _init(type: int) -> void:
		self.type = type
