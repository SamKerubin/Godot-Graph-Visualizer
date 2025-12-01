@tool
extends Resource
class_name ScriptParser

func _parse_literal(tokens: Array[AST.Token], current: int) -> Dictionary:
	var current_token: AST.Token = tokens[current]
	return {
		"node": ScriptAST.LiteralNode.new(current_token.value),
		"next_ind": current + 1
	}

func _parse_class_name(tokens: Array[AST.Token], current: int, line_count: int) -> Dictionary:
	var class_name_node := ScriptAST.ScriptPropertyNode.new(ScriptAST.NodeType.CLASS_NAME, line_count, null)
	current += 1

	while current < tokens.size():
		var token: AST.Token = tokens[current]

		if token.type == ScriptSymbolIndex.SymbolType.NEW_LINE:
			break

		if token.type == ScriptSymbolIndex.SymbolType.NAME:
			class_name_node.identifier = ScriptAST.IdentifierNode.new(token.value)

		current += 1

	return {
		"node": class_name_node,
		"next_ind": current
	}

func _parse_parent_class(tokens: Array[AST.Token], current: int, line_count: int) -> Dictionary:
	var extends_node := ScriptAST.ScriptPropertyNode.new(ScriptAST.NodeType.EXTENDS, line_count, null)

	current += 1

	while current < tokens.size():
		var token: AST.Token = tokens[current]

		if token.type == ScriptSymbolIndex.SymbolType.NEW_LINE:
			break

		if token.type == ScriptSymbolIndex.SymbolType.NAME:
			extends_node.identifier = ScriptAST.IdentifierNode.new(token.value)

		current += 1

	return {
		"node": extends_node,
		"next_ind": current
	}

func _parse_variable(tokens: Array[AST.Token], current: int, line_count: int) -> Dictionary:
	var var_node := ScriptAST.VarDeclNode.new(line_count, null, null)
	current += 1
	while current < tokens.size():
		var token: AST.Token = tokens[current]

		if token.type == ScriptSymbolIndex.SymbolType.NEW_LINE:
			break

		if token.type == ScriptSymbolIndex.SymbolType.NAME:
			var_node.identifier = ScriptAST.IdentifierNode.new(token.value)

		if token.type == ScriptSymbolIndex.SymbolType.EQUAL and var_node.identifier:
			var parsed: Dictionary = _parse_expression(tokens, current, line_count)

			var_node.expression = parsed.get("node")
			line_count = parsed.get("line_count", line_count)
			current = parsed["next_ind"]
			break

		current += 1

	return {
		"node": var_node,
		"next_ind": current,
		"line_count": line_count
	}

func _parse_expression(tokens: Array[AST.Token], current: int, line_count: int) -> Dictionary:
	current += 1
	var parsed: Dictionary = {}
	while current < tokens.size():
		var token: AST.Token = tokens[current]

		if token.type == ScriptSymbolIndex.SymbolType.NEW_LINE:
			break

		if token.type == ScriptSymbolIndex.SymbolType.BACKSLASH:
			current += 2
			line_count += 1
			continue

		if token.type == ScriptSymbolIndex.SymbolType.LITERAL:
			parsed = _parse_literal(tokens, current)
			break

		if token.type == ScriptSymbolIndex.SymbolType.NAME:
			parsed = _parse_name(tokens, current, line_count)
			break

		if token.type == ScriptSymbolIndex.SymbolType.SQUARED and token.value == "[":
			parsed = _parse_array(tokens, current, line_count)
			break

		if token.type == ScriptSymbolIndex.SymbolType.CURLY and token.value == "{":
			parsed = _parse_dictionary(tokens, current, line_count)
			break

		current += 1

	return {
		"node": parsed.get("node"),
		"next_ind": parsed["next_ind"],
		"line_count": parsed.get("line_count", line_count)
	}

func _parse_name(tokens: Array[AST.Token], current: int, line_count: int) -> Dictionary:
	var current_token: AST.Token = tokens[current]
	var name: String = current_token.value

	current += 1
	var parsed: Dictionary = {}
	while current < tokens.size():
		var token: AST.Token = tokens[current]

		if token.type == ScriptSymbolIndex.SymbolType.NEW_LINE:
			break

		if token.type == ScriptSymbolIndex.SymbolType.BACKSLASH:
			current += 2
			line_count += 1
			continue

		if token.type == ScriptSymbolIndex.SymbolType.PARENTHESIS and token.value == "(":
			parsed = _parse_function_call(tokens, current, line_count, name)
			break

		if token.type == ScriptSymbolIndex.SymbolType.SQUARED and token.value == "[":
			parsed = _parse_index(tokens, current, line_count, name)
			break

		if token.type == ScriptSymbolIndex.SymbolType.DOT:
			parsed = _parse_index_or_caller(tokens, current, line_count, name)
			break

	return {
		"node": parsed.get("node"),
		"next_ind": parsed["next_ind"],
		"line_count": parsed.get("line_count", line_count)
	}

func _parse_array(tokens: Array[AST.Token], current: int, line_count: int) -> Dictionary:
	current += 1
	return {
		"next_ind": current
	}

func _parse_dictionary(tokens: Array[AST.Token], current: int, line_count: int) -> Dictionary:
	current += 1
	return {
		"next_ind": current
	}

func _parse_index_or_caller(tokens: Array[AST.Token], current: int, line_count: int, target_name: String) -> Dictionary:
	current += 1
	return {
		"next_ind": current
	}

func _parse_caller(tokens: Array[AST.Token], current: int, line_count: int, target_name: String) -> Dictionary:
	current += 1
	return {
		"next_ind": current
	}

func _parse_index(tokens: Array[AST.Token], current: int, line_count: int, target_name: String) -> Dictionary:
	current += 1
	return {
		"next_ind": current
	}

func _parse_function_call(tokens: Array[AST.Token], current: int, line_count: int, target_name: String) -> Dictionary:
	current += 1
	return {
		"next_ind": current
	}

func _parse_function_decl(tokens: Array[AST.Token], current: int, line_count: int, tab_count: int) -> Dictionary:
	current += 1
	return {
		"next_ind": current
	}

func _parse_args(tokens: Array[AST.Token], current: int, line_count: int) -> Dictionary:
	current += 1
	return {
		"next_ind": current
	}

func _parse_conditional(tokens: Array[AST.Token], current: int, line_count: int, tab_count: int) -> Dictionary:
	current += 1
	return {
		"next_ind": current
	}

func _parse_token(tokens: Array[AST.Token], current: int, line_count: int, tab_count: int) -> Dictionary:
	var token: AST.Token = tokens[current]

	var parsed: Dictionary = {}
	match token.type:
		ScriptSymbolIndex.SymbolType.CLASS_NAME: parsed = _parse_class_name(tokens, current, line_count)
		ScriptSymbolIndex.SymbolType.PARENT_CLASS: parsed = _parse_parent_class(tokens, current, line_count)
		ScriptSymbolIndex.SymbolType.VARIABLE: parsed = _parse_variable(tokens, current, line_count)
		ScriptSymbolIndex.SymbolType.FUNCTION: parsed = _parse_function_decl(tokens, current, line_count, tab_count)
		ScriptSymbolIndex.SymbolType.CONDITIONAL: parsed = _parse_conditional(tokens, current, line_count, tab_count)
		ScriptSymbolIndex.SymbolType.NAME: parsed = _parse_name(tokens, current, line_count)
		ScriptSymbolIndex.SymbolType.RETURNS: parsed = _parse_expression(tokens, current, line_count)
		ScriptSymbolIndex.SymbolType.NEW_LINE:
			parsed = {
				"next_ind": current + 1,
				"line_count": line_count + 1,
				"tab_count": 0
			}
		ScriptSymbolIndex.SymbolType.TABULATION:
			parsed = {
				"next_ind": current + 1,
				"tab_count": tab_count + 1
			}
		_: return _parse_literal(tokens, current)

	return parsed

func parse_script(tokens: Array[AST.Token]) -> ScriptAST.ScopeNode:
	var root: ScriptAST.ScopeNode = ScriptAST.ScopeNode.new(0, [])
	var line_count: int = 1
	var tab_count: int = 0

	var current: int = 0
	while current < tokens.size():
		var parsed: Dictionary = _parse_token(tokens, current, line_count, tab_count)
		if parsed.has("node"):
			root.body.append(parsed["node"])

		line_count = parsed.get("line_count", line_count)
		tab_count = parsed.get("tab_count", tab_count)
		current = parsed["next_ind"]

	return root
