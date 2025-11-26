@tool
extends Resource
class_name ScriptPropertyBuilder

func build_property(ast_root: AST.ASTNode) -> ScriptProperty:
	return ScriptProperty.new()
