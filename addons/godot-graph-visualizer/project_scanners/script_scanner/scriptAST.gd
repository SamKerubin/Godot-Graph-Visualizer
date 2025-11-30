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
	FUNC_CALLER,
	FUNC_DECL,
	INDEX,
	ARRAY,
	DICTIONARY,
	DICT_PAIR,
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
	var target: IdentifierNode
	var expression: ASTNode

	func _init(line: int, target: IdentifierNode, expression: ASTNode) -> void:
		super._init(NodeType.ASSIGNMENT, line)
		self.target = target
		self.expression = expression

class CallNode extends PropertyNode:
	var callable: IdentifierNode
	var args: Array[ASTNode]

	func _init(line: int, callable: IdentifierNode, args: Array[ASTNode]) -> void:
		super._init(NodeType.FUNC_CALL, line)
		self.callable = callable
		self.args = args

class CallerNode extends PropertyNode:
	var caller: IdentifierNode
	var callable: IdentifierNode
	var args: Array[ASTNode]

	func _init(line: int, caller: IdentifierNode, callable: IdentifierNode, args: Array[ASTNode]) -> void:
		super._init(NodeType.FUNC_CALLER, line)
		self.caller = caller
		self.callable = callable
		self.args = args

class IndexNode extends PropertyNode:
	var identifier: IdentifierNode
	var key: IdentifierNode

	func _init(line: int, identifier: IdentifierNode, key: IdentifierNode) -> void:
		super._init(NodeType.INDEX, line)
		self.identifier = identifier
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
	var returns: Array[ASTNode]
	var scope: ScopeNode

	func _init(line: int, 
			identifier: IdentifierNode, 
			params: Array[IdentifierNode],
			returns: Array[ASTNode],
			scope: ScopeNode) -> void:
		super._init(NodeType.FUNC_DECL, line)
		self.identifier = identifier
		self.params = params
		self.returns = returns
		self.scope = scope
