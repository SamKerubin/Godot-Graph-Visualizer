@tool
extends Resource
class_name DocumentationParser

func _parse_line_token(tokens: Array[AST.Token], current: int) -> Dictionary:
	var current_token: AST.Token = tokens[current]
	var node: AST.ASTNode = AST.ASTNode.new(current_token.type, 
											current_token.value, 
											current_token.value, 
											[])
	current += 1
	while current < tokens.size():
		var token: AST.Token = tokens[current]

		var parsed: Dictionary = _parse_token(tokens, current)
		node.children.append(parsed["node"])
		current = parsed["current"]

		if token.type == "text" and token.value.find("\n") != -1:
			break

	return {
		"node": node,
		"current": current
	}

func _parse_inline_token(tokens: Array[AST.Token], current: int) -> Dictionary:
	var current_token: AST.Token = tokens[current]
	var node: AST.ASTNode = AST.ASTNode.new(current_token.type, 
											current_token.value, 
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
	var node: AST.ASTNode = AST.ASTNode.new(current_token.type, 
											current_token.value, 
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
			"node": AST.ASTNode.new("text", "text", token.value, []),
			"current": current
		}

func _parse_token(tokens: Array[AST.Token], current: int) -> Dictionary:
	var token: AST.Token = tokens[current]

	var token_parser: Callable
	match token.type:
		"text": token_parser = _parse_text_token
		"line": token_parser = _parse_line_token
		"inline": token_parser = _parse_inline_token
		"block": token_parser = _parse_block_token
		_: pass

	if not token_parser:
		return {
			"node": AST.ASTNode.new("text", "text", token.value, []),
			"current": current
		}

	return token_parser.call(tokens, current)

func parse(tokens: Array[AST.Token]) -> AST.ASTNode:
	var root: AST.ASTNode = AST.ASTNode.new("root", "root", "root", [])
	var current: int = 0

	while current < tokens.size():
		var parsed: Dictionary = _parse_token(tokens, current)
		root.children.append(parsed["node"])
		current = parsed["current"]

	return root
