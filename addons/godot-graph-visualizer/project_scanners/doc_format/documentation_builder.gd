@tool
extends Resource
class_name DocumentationBuilder

func _build_node(node: DocAST.TagNode) -> String:
	if node.type == BBCodeSyntaxIndex.TagType.TEXT:
		return node.value

	var open_tag: String = BBCodeSyntaxIndex.get_bbcode_open_tag(node.value)
	var close_tag: String = BBCodeSyntaxIndex.get_bbcode_close_tag(node.value)

	var built_node: String = open_tag
	for n: DocAST.TagNode in node.children:
		built_node += _build_node(n)
	built_node += close_tag

	return built_node

func build_ast(ast: DocAST.TagNode) -> String:
	var build: String = ""
	for n: DocAST.TagNode in ast.children:
		build += _build_node(n)

	return build
