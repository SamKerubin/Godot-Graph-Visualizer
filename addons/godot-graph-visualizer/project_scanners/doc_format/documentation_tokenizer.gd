@tool
extends Resource
class_name DocumentationTokenizer

func _is_tag_start(c: String) -> bool:
	return c in ["[", "<", "*", "_", "`", "#", ">", "-"] #...

func _is_open_tag(c: String) -> bool:
	return c in ["<", "["]

func _tokenize_text(text: String, start: int) -> Dictionary:
	var i: int = start
	var buffer: String = ""

	while i < text.length() and not _is_tag_start(text[i]):
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
	var is_closing: bool = false

	if _is_open_tag(start_char):
		var end_char: String = ">" if start_char == "<" else "]"
		i += 1

		while i < text.length() and text[i] != end_char:
			if text[i] == "/":
				is_closing = true
				i += 1

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

		var unknown_tag: String = start_char
		if is_closing:
			unknown_tag += "/"
		unknown_tag += tag_value + end_char
	
		return {
			"token": AST.Token.new("text", unknown_tag),
			"next_ind": i
		}

	var last_valid: String = ""
	var last_valid_ind: int = start

	while i < text.length() and _is_tag_start(text[i]):
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

	return {
		"token": AST.Token.new("text", buffer),
		"next_ind": last_valid_ind
	}

func tokenize(text: String) -> Array[AST.Token]:
	var tokens: Array[AST.Token] = []
	var current: int = 0

	while current < text.length():
		var c: String = text[current]
		if _is_tag_start(c):
			var tag_token: Dictionary = _tokenize_tag(text, current)
			tokens.append(tag_token["token"])
			current = tag_token["next_ind"]
		else:
			var text_token: Dictionary = _tokenize_text(text, current)
			tokens.append(text_token["token"])
			current = text_token["next_ind"]

	return tokens
