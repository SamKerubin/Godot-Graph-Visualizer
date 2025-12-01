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

		if token.type == ScriptSymbolIndex.SymbolType.BACKSLASH:
			current += 2
			line_count += 1
			continue

		if token.type == ScriptSymbolIndex.SymbolType.NAME:
			class_name_node.identifier = ScriptAST.IdentifierNode.new(token.value)
			current += 1
			break

		current += 1

	return {
		"node": class_name_node,
		"line_count": line_count,
		"next_ind": current
	}

func _parse_parent_class(tokens: Array[AST.Token], current: int, line_count: int) -> Dictionary:
	var extends_node := ScriptAST.ScriptPropertyNode.new(ScriptAST.NodeType.EXTENDS, line_count, null)
	current += 1

	while current < tokens.size():
		var token: AST.Token = tokens[current]

		if token.type == ScriptSymbolIndex.SymbolType.NEW_LINE:
			break

		if token.type == ScriptSymbolIndex.SymbolType.BACKSLASH:
			current += 2
			line_count += 1
			continue

		if token.type == ScriptSymbolIndex.SymbolType.NAME:
			extends_node.identifier = ScriptAST.IdentifierNode.new(token.value)
			current += 1
			break

		current += 1

	return {
		"node": extends_node,
		"line_count": line_count,
		"next_ind": current
	}

func _parse_variable(tokens: Array[AST.Token], current: int, line_count: int) -> Dictionary:
	var var_node := ScriptAST.VarDeclNode.new(line_count, null, null)
	current += 1
	while current < tokens.size():
		var token: AST.Token = tokens[current]

		if token.type == ScriptSymbolIndex.SymbolType.NEW_LINE:
			break

		if token.type == ScriptSymbolIndex.SymbolType.BACKSLASH:
			current += 2
			line_count += 1
			continue

		if token.type == ScriptSymbolIndex.SymbolType.NAME:
			var_node.identifier = ScriptAST.IdentifierNode.new(token.value)
			current += 1
			continue

		if token.type == ScriptSymbolIndex.SymbolType.EQUAL and var_node.identifier and not var_node.expression:
			current += 1
			var parsed: Dictionary = _parse_expression(tokens, current, line_count, false)

			var_node.expression = parsed.get("node")
			line_count = parsed["line_count"]
			current = parsed["next_ind"]
			continue

		current += 1

	return {
		"node": var_node,
		"next_ind": current,
		"line_count": line_count
	}

func _parse_primary(tokens: Array[AST.Token], current: int, line_count: int) -> Dictionary:
	while current < tokens.size():
		var token: AST.Token = tokens[current]

		if token.type == ScriptSymbolIndex.SymbolType.NEW_LINE:
			break

		if token.type == ScriptSymbolIndex.SymbolType.BACKSLASH:
			current += 2
			line_count += 1
			continue

		if token.type == ScriptSymbolIndex.SymbolType.NAME:
			return _parse_name(tokens, current)

		if token.type == ScriptSymbolIndex.SymbolType.SQUARED and token.value == "[":
			return _parse_array(tokens, current, line_count)

		if token.type == ScriptSymbolIndex.SymbolType.CURLY and token.value == "{":
			return _parse_dictionary(tokens, current, line_count)

		if token.type == ScriptSymbolIndex.SymbolType.LITERAL:
			return _parse_literal(tokens, current)

	return {
		"next_ind": current,
		"line_count": line_count
	}

func _parse_postfix_chain(tokens: Array[AST.Token], primary: Dictionary, line_count: int) -> Dictionary:
	var node := primary.get("node")
	var current: int = primary["next_ind"]

	while current < tokens.size():
		var token: AST.Token = tokens[current]

		if token.type == ScriptSymbolIndex.SymbolType.NEW_LINE:
			break

		if token.type == ScriptSymbolIndex.SymbolType.BACKSLASH:
			current += 2
			line_count += 1
			continue

		if token.type == ScriptSymbolIndex.SymbolType.DOT:
			current += 1
			var name: String = tokens[current].value
			node = ScriptAST.MemberAcessNode.new(line_count, node, ScriptAST.IdentifierNode.new(name))
			current += 1
			continue

		if token.type == ScriptSymbolIndex.SymbolType.PARENTHESIS and token.value == "(":
			var call_node: Dictionary = _parse_function_call(tokens, current, line_count, node)
			node = call_node["node"]
			current = call_node["next_ind"]
			line_count = call_node["line_count"]
			continue

		if token.type == ScriptSymbolIndex.SymbolType.SQUARED and token.value == "[":
			var index_node: Dictionary = _parse_index(tokens, current, line_count, node)
			node = index_node["node"]
			current = index_node["next_ind"]
			line_count = index_node["line_count"]
			continue

		break

	return {
		"node": node,
		"next_ind": current,
		"line_count": line_count
	}

func _parse_expression(tokens: Array[AST.Token], current: int, line_count: int, expects_assign: bool) -> Dictionary:
	var primary: Dictionary = _parse_primary(tokens, current, line_count)
	primary = _parse_postfix_chain(tokens, primary, primary.get("line_count", line_count))

	line_count = primary["line_count"]
	current = primary["next_ind"]

	while current < tokens.size() and expects_assign:
		var token: AST.Token = tokens[current]

		if token.type == ScriptSymbolIndex.SymbolType.NEW_LINE:
			break

		if token.type == ScriptSymbolIndex.SymbolType.BACKSLASH:
			current += 2
			line_count += 1
			continue

		if token.type == ScriptSymbolIndex.SymbolType.EQUAL:
			current += 1
			var parsed: Dictionary = _parse_expression(tokens, current, line_count, false)
			return {
				"node": ScriptAST.AssignmentNode.new(line_count, primary["node"], parsed["node"]),
				"next_ind": parsed["next_ind"],
				"line_count": parsed.get("line_count", line_count)
			}

		current += 1

	return primary

func _parse_name(tokens: Array[AST.Token], current: int) -> Dictionary:
	var name: String = tokens[current].value
	return {
		"node": ScriptAST.IdentifierNode.new(name),
		"next_ind": current + 1
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

func _parse_index(tokens: Array[AST.Token], current: int, line_count: int, node: Dictionary) -> Dictionary:
	var index_node := ScriptAST.MemberAcessNode.new(line_count, node["node"], null)
	current += 1

	while current < tokens.size():
		var token: AST.Token = tokens[current]

		if token.type == ScriptSymbolIndex.SymbolType.NEW_LINE:
			line_count += 1
			current += 1
			continue

		if token.type == ScriptSymbolIndex.SymbolType.SQUARED and token.value == "]":
			current += 1
			break

		var expression: Dictionary = _parse_expression(tokens, current, line_count, false)
		index_node.key = expression["node"]
		current = expression["next_ind"]
		line_count = expression.get("line_count", line_count)

	return {
		"node": index_node,
		"next_ind": current,
		"line_count": line_count
	}

func _parse_function_call(tokens: Array[AST.Token], current: int, line_count: int, node: Dictionary) -> Dictionary:
	var call_node := ScriptAST.CallNode.new(line_count, node["node"], [])
	current += 1

	while current < tokens.size():
		var token: AST.Token = tokens[current]

		if token.type == ScriptSymbolIndex.SymbolType.NEW_LINE:
			line_count += 1
			current += 1
			continue

		if token.type == ScriptSymbolIndex.SymbolType.PARENTHESIS and token.value == ")":
			current += 1
			break

		if token.type == ScriptSymbolIndex.SymbolType.COMMA:
			current += 1
			continue

		var expression: Dictionary = _parse_expression(tokens, current, line_count, false)
		call_node.args.append(expression["node"])
		current = expression["next_ind"]
		line_count = expression.get("line_count", line_count)

	return {
		"node": call_node,
		"next_ind": current,
		"line_count": line_count
	}

func _parse_function_decl(tokens: Array[AST.Token], current: int, line_count: int, tab_count: int) -> Dictionary:
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
		ScriptSymbolIndex.SymbolType.NAME: parsed = _parse_expression(tokens, current, line_count, true)
		ScriptSymbolIndex.SymbolType.RETURNS: parsed = _parse_expression(tokens, current, line_count, false)
		ScriptSymbolIndex.SymbolType.NEW_LINE:
			parsed = {
				"next_ind": current + 1,
				"line_count": line_count + 1,
				"tab_count": 0
			}
		ScriptSymbolIndex.SymbolType.TABULATION:
			parsed = {
				"next_ind": current + 1,
				"line_count": line_count,
				"tab_count": tab_count + 1
			}
		ScriptSymbolIndex.SymbolType.BACKSLASH:
			parsed = {
				"next_ind": current + 2,
				"line_count": line_count + 1,
				"tab_count": 0
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
