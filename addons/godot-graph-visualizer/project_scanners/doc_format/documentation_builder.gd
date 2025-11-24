@tool
extends Resource
class_name DocumentationBuilder

func _build_node(node: AST.ASTNode) -> String:
	if node.type == "text":
		return node.value

	var open_tag: String = BBCodeSyntaxIndex.get_bbcode_open_tag(node.value)
	var close_tag: String = BBCodeSyntaxIndex.get_bbcode_close_tag(node.value)

	var built_node: String = open_tag
	for n: AST.ASTNode in node.children:
		built_node += _build_node(n)
	built_node += close_tag

	return built_node

func build_ast(ast: AST.ASTNode) -> String:
	var build: String = ""
	for n: AST.ASTNode in ast.children:
		build += _build_node(n)

	return build
