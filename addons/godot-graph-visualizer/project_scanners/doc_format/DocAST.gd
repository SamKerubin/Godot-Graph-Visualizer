@tool
extends Resource
class_name DocAST

class TagNode extends AST.ASTNode:
	var children: Array[TagNode]

	func _init(type: int, value: String, children: Array[TagNode]) -> void:
		super._init(type, value)
		self.children = children
