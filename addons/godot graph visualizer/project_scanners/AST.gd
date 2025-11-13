@tool
extends Resource
class_name AST

class Token:
	var type: String
	var value: String

	func _init(type: String, value: String) -> void:
		self.type = type
		self.value = value

class ASTNode:
	var type: String
	var name: String
	var value: String
	var children: Array[ASTNode]
	
	func _init(type: String, name: String, value: String, children: Array[ASTNode]) -> void:
		self.type = type
		self.name = name
		self.value = value
		self.children = children
