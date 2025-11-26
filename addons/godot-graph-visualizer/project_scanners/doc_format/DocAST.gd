@tool
extends AST
class_name DocAST

class TagNode extends ASTNode:
	var value: String
	var children: Array[TagNode]

	func _init(type: int, value: String, children: Array[TagNode]) -> void:
		super._init(type)
		self.value = value
		self.children = children
