@tool
extends Resource
class_name DocumentationFormatter

## Class for formatting doc strings
## It supports:[br]
## - BBcode (by default)[br]
## - Markdown (later)[br]
## - HTML (later)[br]

func is_tag_start(c: String) -> bool:
	return c in ["[", "<", "*", "_", "`", "#"]

func is_opening_tag(c: String) -> bool:
	return c in ["<", "["]

#region Tokenizer
func _tokenize_text(text: String, start: int) -> Dictionary:
	var i: int = start
	var buffer: String = ""

	while i < text.length() and not is_tag_start(text[i]):
		buffer += text[i]
		i += 1

	return {
		"token": AST.Token.new("text", buffer),
		"next_ind": i
	}

func _tokenize_tag(text: String, start: int) -> Dictionary:
	var i: int = start
	var buffer: String = ""
	var start_char: String = text[i]

	if is_opening_tag(start_char):
		var end_char: String = ">" if start_char == "<" else "]"
		i += 1

		while i < text.length() and text[i] != end_char:
			buffer += text[i]
			i += 1

		i += 1
		var tag_value: String = buffer.strip_edges()

		if BBCodeSyntaxIndex.has_tag(tag_value):
			var tag_type: String = BBCodeSyntaxIndex.get_tag_type(tag_value)
			return {
				"token": AST.Token.new(tag_type, tag_value),
				"next_ind": i
			}

		return _tokenize_text(text, start)

	var last_valid: String = ""
	var last_valid_ind: int = start

	while i < text.length() and is_tag_start(text[i]):
		buffer += text[i]
		if BBCodeSyntaxIndex.has_tag(buffer):
			last_valid = buffer
			last_valid_ind = i + 1

		i += 1

	if not last_valid.is_empty():
		var tag_type: String = BBCodeSyntaxIndex.get_tag_type(last_valid)
		return {
			"token": AST.Token.new(tag_type, last_valid),
			"next_ind": last_valid_ind
		}

	return _tokenize_text(text, start)

func _tokenize(text: String) -> Array[AST.Token]:
	var tokens: Array[AST.Token] = []
	var current: int = 0

	while current < text.length():
		var c: String = text[current]
		if is_tag_start(c):
			var tag_token: Dictionary = _tokenize_tag(text, current)
			tokens.append(tag_token["token"])
			current = tag_token["next_ind"]
		else:
			var text_token: Dictionary = _tokenize_text(text, current)
			tokens.append(text_token["token"])
			current = text_token["next_ind"]

	return tokens
#endregion

#region Parser
func _parse_line_token(tokens: Array[AST.Token], current: int, node: AST.ASTNode) -> Dictionary:
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

func _parse_inline_token(tokens: Array[AST.Token], current: int, node: AST.ASTNode) -> Dictionary:
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

func _parse_token(tokens: Array[AST.Token], current: int) -> Dictionary:
	var token: AST.Token = tokens[current]

	if token.type == "text":
		current += 1
		return {
			"node": AST.ASTNode.new("text", "text", token.value, []),
			"current": current
		}

	var token_parser: Callable
	match token.type:
		"line": token_parser = _parse_line_token
		"inline": token_parser = _parse_inline_token
		_: pass

	if not token_parser:
		return {
			"node": AST.ASTNode.new("text", "text", token.value, []),
			"current": current
		}

	var tag_name: String = BBCodeSyntaxIndex.get_tag_name(token.value)
	var node: AST.ASTNode = AST.ASTNode.new(token.type, tag_name, token.value, [])

	current += 1
	return token_parser.call(tokens, current, node)

func _parse(tokens: Array[AST.Token]) -> AST.ASTNode:
	var root: AST.ASTNode = AST.ASTNode.new("root", "root", "root", [])
	var current: int = 0

	while current < tokens.size():
		var parsed: Dictionary = _parse_token(tokens, current)
		root.children.append(parsed["node"])
		current = parsed["current"]

	return root

#func printAST(root: AST.ASTNode, depth: int) -> void:
	#var message: String = ""
	#var i: int = 0
	#while i < depth:
		#message += "  "
		#i += 1
#
	#if i != 0:
		#message += "|_"
#
	#message += "name=%s, type=%s, value=%s"
#
	#print(message % [root.name, root.type, root.value])
	#for c: AST.ASTNode in root.children:
		#printAST(c, depth + 1)
#endregion

func format_text(text: String) -> String:
	if text.is_empty():
		return "This scene does not have a provided description within" \
		+ "the property \'Editor Description\'"

	var tokens: Array[AST.Token] = _tokenize(text)
	var ast_root: AST.ASTNode = _parse(tokens)

	return ""
