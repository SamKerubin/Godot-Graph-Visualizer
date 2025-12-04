@tool
extends AST
class_name ScriptAST

enum NodeType {
	CLASS_NAME,
	EXTENDS,
	IDENTIFIER,
	LITERAL,
	VAR_DECL,
	ASSIGNMENT,
	FUNC_CALL,
	FUNC_DECL,
	MEMBER_ACESS,
	ARRAY,
	DICTIONARY,
	DICT_PAIR,
	FOR_LOOP,
	SCOPE
}

class PropertyNode extends ASTNode:
	var line: int

	func _init(type: int, line: int) -> void:
		super._init(type)
		self.line = line

class IdentifierNode extends ASTNode:
	var name: String

	func _init(name: String) -> void:
		super._init(NodeType.IDENTIFIER)
		self.name = name

class ScriptPropertyNode extends PropertyNode:
	var identifier: IdentifierNode

	func _init(type: int, line: int, identifier: IdentifierNode) -> void:
		super._init(type, line)
		self.identifier = identifier

class LiteralNode extends ASTNode:
	var value: Variant

	func _init(value: Variant) -> void:
		super._init(NodeType.LITERAL)
		self.value = value

class VarDeclNode extends PropertyNode:
	var identifier: IdentifierNode
	var expression: ASTNode

	func _init(line: int, identifier: IdentifierNode, expression: ASTNode) -> void:
		super._init(NodeType.VAR_DECL, line)
		self.identifier = identifier
		self.expression = expression

class AssignmentNode extends PropertyNode:
	var target: ASTNode
	var expression: ASTNode

	func _init(line: int, target: ASTNode, expression: ASTNode) -> void:
		super._init(NodeType.ASSIGNMENT, line)
		self.target = target
		self.expression = expression

class CallNode extends PropertyNode:
	var callable: ASTNode
	var args: Array[ASTNode]

	func _init(line: int, callable: ASTNode, args: Array[ASTNode]) -> void:
		super._init(NodeType.FUNC_CALL, line)
		self.callable = callable
		self.args = args

class MemberAcessNode extends PropertyNode:
	var source: ASTNode
	var key: ASTNode

	func _init(line: int, source: ASTNode, key: ASTNode) -> void:
		super._init(NodeType.MEMBER_ACESS, line)
		self.source = source
		self.key = key

class ArrayNode extends LiteralNode:
	func _init(elements: Array[ASTNode]) -> void:
		super._init(elements)

class DictPairNode extends PropertyNode:
	var key: ASTNode
	var value: ASTNode

	func _init(line: int, key: ASTNode, value: ASTNode) -> void:
		super._init(NodeType.DICT_PAIR, line)
		self.key = key
		self.value = value

class DictionaryNode extends LiteralNode:
	func _init(pairs: Array[DictPairNode]) -> void:
		super._init(pairs)

class ScopeNode extends PropertyNode:
	var body: Array[ASTNode]

	func _init(line: int, body: Array[ASTNode]) -> void:
		super._init(NodeType.SCOPE, line)
		self.body = body

class FuncDeclNode extends PropertyNode:
	var identifier: IdentifierNode
	var params: Array[IdentifierNode]
	var scope: ScopeNode

	func _init(line: int, 
			identifier: IdentifierNode, 
			params: Array[IdentifierNode],
			scope: ScopeNode) -> void:
		super._init(NodeType.FUNC_DECL, line)
		self.identifier = identifier
		self.params = params
		self.scope = scope

class FoorLoopNode extends PropertyNode:
	var variable: IdentifierNode
	var scope: ScopeNode

	func _init(line: int, variable: IdentifierNode, scope: ScopeNode) -> void:
		super._init(NodeType.FOR_LOOP, line)
		self.variable = variable
		self.scope = scope
