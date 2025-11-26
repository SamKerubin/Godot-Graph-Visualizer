@tool
extends Resource
class_name ScriptParser

func parse_script(tokens: Array[AST.Token]) -> AST.ASTNode:
	var root: AST.ASTNode = AST.ASTNode.new("global", "global", "global", [])
	return root
