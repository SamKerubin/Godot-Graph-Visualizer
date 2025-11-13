@tool
extends Resource
class_name DocumentationFormatter

## Class for formatting doc strings
## It supports:[br]
## - BBcode (by default)[br]
## - Markdown (later)[br]
## - HTML (later)[br]

class Token:
	var type: String
	var value: String

	func _init(type: String, value: String) -> void:
		self.type = type
		self.value = value

class ASTNode:
	var type: String
	var name: String
	var value: String
	var children: Array[ASTNode]
	
	func _init(type: String, name: String, value: String, children: Array[ASTNode]) -> void:
		self.type = type
		self.name = name
		self.value = value
		self.children = children

func is_tag(c: String) -> bool:
	return not BBCodeSyntaxIndex.get_bbcode_tag(c).is_empty() \
			or is_opening_tag(c)

func is_opening_tag(c: String) -> bool:
	return c in ["<", "["]

func is_closing_tag(c: String) -> bool:
	return c in [">", "]"]

#region Tokenizer
func tokenize_text(text: String, start: int) -> Dictionary:
	var i: int = start
	var buffer: String = ""

	while i < text.length() and not is_tag(text[i]):
		buffer += text[i]
		i += 1

	return {
		"token": Token.new("text", buffer),
		"next_ind": i
	}

func tokenize_tag(text: String, start: int) -> Dictionary:
	var i: int = start
	var buffer: String = ""
	var is_opening: bool = is_opening_tag(text[i])

	if is_opening:
		i += 1

	while i < text.length() and (is_tag(text[i]) or is_opening):
		var c: String = text[i]

		if is_closing_tag(c) and is_opening:
			i += 1
			break

		if c == "/":
			i += 1
			continue

		buffer += c
		i += 1

	var tag_type: String = BBCodeSyntaxIndex.get_tag_type(buffer)

	return {
		"token": Token.new(tag_type, buffer),
		"next_ind": i
	}

func tokenize(text: String) -> Array[Token]:
	var tokens: Array[Token] = []
	var current: int = 0

	while current < text.length():
		var c: String = text[current]
		if is_tag(c):
			var tag_token: Dictionary = tokenize_tag(text, current)
			tokens.append(tag_token["token"])
			current = tag_token["next_ind"]
		else:
			var text_token: Dictionary = tokenize_text(text, current)
			tokens.append(text_token["token"])
			current = text_token["next_ind"]

	return tokens
#endregion

#region Parser
func parse_token(tokens: Array[Token], current: int) -> Dictionary:
	var token: Token = tokens[current]

	if token.type == "text":
		current += 1
		return {
			"node": ASTNode.new("text", "text", token.value, []),
			"current": current
		}

	var tag_name: String = BBCodeSyntaxIndex.get_tag_name(token.value)
	var node: ASTNode = ASTNode.new(token.type, tag_name, token.value, [])

	current += 1
	token = tokens[current]
	while current < tokens.size() and not (token.type != "text" and token.value != "\n"):
		var parsed: Dictionary = parse_token(tokens, current)
		node.children.append(parsed["node"])
		current = parsed["current"]
		token = tokens[current]

	return {
		"node": node,
		"current": current
	}

func parse(tokens: Array[Token]) -> ASTNode:
	var root: ASTNode = ASTNode.new("root", "root", "root", [])
	var current: int = 0

	while current < tokens.size():
		var parsed: Dictionary = parse_token(tokens, current)
		root.children.append(parsed["node"])
		current = parsed["current"]

	return root

func printAST(root: ASTNode, depth: int) -> void:
	var message: String = ""
	var i: int = 0
	while i < depth:
		message += "  "

	message += "name=%s, type=%s, value=%s"

	print(message % [root.name, root.type, root.value])
	for c: ASTNode in root.children:
		printAST(c, depth + 1)
#endregion

func format_text(text: String) -> String:
	if text.is_empty():
		return "This scene does not have a provided description within" \
		+ "the property \'Editor Description\'"

	var tokens: Array[Token] = tokenize(text)
	
	for t in tokens:
		print("{type=%s, value=%s}" % [t.type, t.value])
	
	#var ast_root: ASTNode = parse(tokens)

	#printAST(ast_root, 0)

	return ""
