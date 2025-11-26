@tool
extends Resource
class_name ScriptParser

func parse_script(tokens: Array[AST.Token]) -> AST.ASTNode:
	var root: AST.ASTNode = ScriptAST.ScopeNode.new(0, [])
	return root
