@tool
extends Resource
class_name DocumentationParser

func _parse_line_token(tokens: Array[AST.Token], current: int) -> Dictionary:
	var current_token: AST.Token = tokens[current]
	var node: DocAST.TagNode = DocAST.TagNode.new(current_token.type, 
											current_token.value,
											[])
	current += 1
	while current < tokens.size():
		var token: AST.Token = tokens[current]

		var parsed: Dictionary = _parse_token(tokens, current)
		node.children.append(parsed["node"])
		current = parsed["current"]

		if token.type == BBCodeSyntaxIndex.TagType.TEXT and token.value.find("\n") != -1:
			break

	return {
		"node": node,
		"current": current
	}

func _parse_inline_token(tokens: Array[AST.Token], current: int) -> Dictionary:
	var current_token: AST.Token = tokens[current]
	var node: DocAST.TagNode = DocAST.TagNode.new(current_token.type, 
											current_token.value,
											[])
	current += 1
	while current < tokens.size():
		var token: AST.Token = tokens[current]
		if token.type == node.type and token.value == node.value:
			current += 1
			break

		var parsed: Dictionary = _parse_token(tokens, current)
		node.children.append(parsed["node"])
		current = parsed["current"]

	return {
		"node": node,
		"current": current
	}

func _parse_block_token(tokens: Array[AST.Token], current: int) -> Dictionary:
	var current_token: AST.Token = tokens[current]
	var node: DocAST.TagNode = DocAST.TagNode.new(current_token.type, 
											current_token.value,
											[])
	current += 1
	while current < tokens.size():
		var token: AST.Token = tokens[current]
		
		if token.type == node.type and token.value == node.value:
			current += 1
			break

		var parsed: Dictionary = _parse_text_token(tokens, current)
		node.children.append(parsed["node"])
		current = parsed["current"]

	return {
		"node": node,
		"current": current
	}

func _parse_text_token(tokens: Array[AST.Token], current: int) -> Dictionary:
	var token: AST.Token = tokens[current]
	current += 1
	return {
		"node": DocAST.TagNode.new(BBCodeSyntaxIndex.TagType.TEXT, token.value, []),
		"current": current
	}

func _parse_token(tokens: Array[AST.Token], current: int) -> Dictionary:
	var token: AST.Token = tokens[current]

	var token_parser: Callable
	match token.type:
		BBCodeSyntaxIndex.TagType.TEXT: token_parser = _parse_text_token
		BBCodeSyntaxIndex.TagType.LINE: token_parser = _parse_line_token
		BBCodeSyntaxIndex.TagType.INLINE: token_parser = _parse_inline_token
		BBCodeSyntaxIndex.TagType.BLOCK: token_parser = _parse_block_token
		_: pass

	if not token_parser.is_valid():
		return {
			"node": DocAST.TagNode.new(BBCodeSyntaxIndex.TagType.TEXT, token.value, []),
			"current": current
		}

	return token_parser.call(tokens, current)

func parse(tokens: Array[AST.Token]) -> DocAST.TagNode:
	var root: DocAST.TagNode = DocAST.TagNode.new(BBCodeSyntaxIndex.TagType.ROOT, "root", [])
	var current: int = 0

	while current < tokens.size():
		var parsed: Dictionary = _parse_token(tokens, current)
		root.children.append(parsed["node"])
		current = parsed["current"]

	return root
