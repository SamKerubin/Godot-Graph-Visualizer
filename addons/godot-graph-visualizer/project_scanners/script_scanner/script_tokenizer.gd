@tool
extends Resource
class_name ScriptTokenizer

func _is_special_symbol(c: String) -> bool:
	return c in ["=", "\n", "\t", "[", "(", "{", "}", ")", "]", ",", ".", ":", "\\"]

func _is_white_space(c: String) -> bool:
	return c == " "

func _is_string_indicator(c: String) -> bool:
	return c == "\"" or c == "'"

func _is_comment_indicator(c: String) -> bool:
	return c == "#"

func _tokenize_special_symbol(c: String, current: int) -> Dictionary:
	var type: String = ScriptSymbolIndex.get_symbol_type(c)
	return {
		"token": AST.Token.new(type, c),
		"next_ind": current + 1
	}

func _tokenize_symbol(content: String, start: int) -> Dictionary:
	var i: int = start
	var buffer: String = ""

	while i < content.length()                 and \
		not _is_special_symbol(content[i])     and \
		not _is_white_space(content[i])        and \
		not _is_comment_indicator(content[i])  and \
		not _is_string_indicator(content[i]):
		buffer += content[i]
		i += 1

	var type: String = ScriptSymbolIndex.get_symbol_type(buffer)
	return {
		"token": AST.Token.new(type, buffer),
		"next_ind": i
	}

func _tokenize_string(content: String, start: int) -> Dictionary:
	var quote: String = content[start]
	var i: int = start + 1
	var buffer: String = ""

	while i < content.length() and content[i] != quote:
		buffer += content[i]
		i += 1

	if i < content.length():
		i += 1

	return {
		"token": AST.Token.new("literal", buffer),
		"next_ind": i
	}

func _ignore_comment(content: String, start: int) -> Dictionary:
	var i: int = start

	while i < content.length() and content[i] != "\n":
		i += 1

	return {
		"next_ind": i
	}

func tokenize(content: String) -> Array[AST.Token]:
	var tokens: Array[AST.Token] = []
	var current: int = 0

	while current < content.length():
		var c: String = content[current]
		var token: Dictionary = {}

		if _is_white_space(c):
			current += 1
			continue

		elif _is_string_indicator(c):
			token = _tokenize_string(content, current)

		elif _is_comment_indicator(c):
			token = _ignore_comment(content, current)

		elif _is_special_symbol(c):
			token = _tokenize_special_symbol(c, current)

		else:
			token = _tokenize_symbol(content, current)

		if token.has("token"):
			tokens.append(token["token"])
		current = token["next_ind"]

	return tokens
