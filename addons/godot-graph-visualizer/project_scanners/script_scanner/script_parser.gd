@tool
extends Resource
class_name ScriptParser

func parse_script(tokens: Array[AST.Token]) -> ScriptProperty:
	return ScriptProperty.new()
