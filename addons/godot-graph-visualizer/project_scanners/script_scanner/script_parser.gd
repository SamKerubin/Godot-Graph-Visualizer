@tool
extends Resource
class_name ScriptParser

const _SYMBOLS := ScriptSymbolIndex.SymbolType

func _skip_until(stop_tokens: Array[ScriptSymbolIndex.SymbolType],
				tokens: Array[AST.Token],
				current: int,
				line_count: int) -> Dictionary:
	while current < tokens.size():
		if tokens[current].type == _SYMBOLS.BACKSLASH:
			current += 2
			line_count += 1
			continue

		if tokens[current].type == _SYMBOLS.NEW_LINE and not _SYMBOLS.NEW_LINE in stop_tokens:
			current += 1
			line_count += 1
			continue

		if tokens[current].type in stop_tokens:
			break

		current += 1

	return {
		"next_ind": clamp(current, 0, tokens.size() - 1),
		"line_count": line_count
	}

func _parse_literal(tokens: Array[AST.Token], current: int, line_count: int) -> Dictionary:
	var literal := tokens[current].value
	return {
		"node": ScriptAST.LiteralNode.new(literal),
		"next_ind": current + 1,
		"line_count": line_count + literal.count("\n", 0, literal.length())
	}

func _parse_class_name(tokens: Array[AST.Token], current: int, line_count: int) -> Dictionary:
	var class_name_node := ScriptAST.ScriptPropertyNode.new(ScriptAST.NodeType.CLASS_NAME, line_count, null)
	current += 1

	var skip: Dictionary = _skip_until([_SYMBOLS.NEW_LINE, _SYMBOLS.NAME], tokens, current, line_count)
	current = skip["next_ind"]
	line_count = skip["line_count"]

	var token := tokens[current]

	if token.type == _SYMBOLS.NAME:
		class_name_node.identifier = ScriptAST.IdentifierNode.new(token.value)

	current += 1

	return {
		"node": class_name_node,
		"line_count": line_count,
		"next_ind": current
	}

func _parse_parent_class(tokens: Array[AST.Token], current: int, line_count: int) -> Dictionary:
	var extends_node := ScriptAST.ScriptPropertyNode.new(ScriptAST.NodeType.EXTENDS, line_count, null)
	current += 1

	var skip: Dictionary = _skip_until([_SYMBOLS.NEW_LINE, _SYMBOLS.NAME], tokens, current, line_count)
	current = skip["next_ind"]
	line_count = skip["line_count"]

	var token := tokens[current]

	if token.type == _SYMBOLS.NAME:
		extends_node.identifier = ScriptAST.IdentifierNode.new(token.value)

	current += 1

	return {
		"node": extends_node,
		"line_count": line_count,
		"next_ind": current
	}

func _parse_variable(tokens: Array[AST.Token], current: int, line_count: int) -> Dictionary:
	var var_node := ScriptAST.VarDeclNode.new(line_count, null, null)
	current += 1

	var skip: Dictionary = _skip_until([_SYMBOLS.NEW_LINE, _SYMBOLS.NAME], tokens, current, line_count)
	current = skip["next_ind"]
	line_count = skip["line_count"]

	var token := tokens[current]

	if token.type == _SYMBOLS.NAME and not var_node.identifier:
		var_node.identifier = ScriptAST.IdentifierNode.new(token.value)
		current += 1

	skip = _skip_until([_SYMBOLS.NEW_LINE, _SYMBOLS.EQUAL], tokens, current, line_count)
	current = skip["next_ind"]
	line_count = skip["line_count"]

	token = tokens[current]
	if token.type == _SYMBOLS.EQUAL and var_node.identifier:
		current += 1
		var parsed: Dictionary = _parse_expression(tokens, current, line_count, false)

		var_node.expression = parsed.get("node")
		line_count = parsed["line_count"]
		current = parsed["next_ind"]

	return {
		"node": var_node,
		"next_ind": current,
		"line_count": line_count
	}

func _parse_primary(tokens: Array[AST.Token], current: int, line_count: int) -> Dictionary:
	var skip: Dictionary = _skip_until([_SYMBOLS.NEW_LINE,
										_SYMBOLS.NAME,
										_SYMBOLS.SQUARED,
										_SYMBOLS.CURLY,
										_SYMBOLS.LITERAL], tokens, current, line_count)
	current = skip["next_ind"]
	line_count = skip["line_count"]

	if current >= tokens.size():
		return {
			"node": null,
			"next_ind": current,
			"line_count": line_count
		}

	var token := tokens[current]

	if token.type == _SYMBOLS.NAME:
		return {
			"node": ScriptAST.IdentifierNode.new(token.value),
			"next_ind": current + 1,
			"line_count": line_count
		}

	if token.type == _SYMBOLS.SQUARED and token.value == "[":
		return _parse_array(tokens, current, line_count)

	if token.type == _SYMBOLS.CURLY and token.value == "{":
		return _parse_dictionary(tokens, current, line_count)

	if token.type == _SYMBOLS.LITERAL:
		return _parse_literal(tokens, current, line_count)

	return {
		"node": null,
		"next_ind": current,
		"line_count": line_count
	}

func _parse_postfix_chain(tokens: Array[AST.Token], primary: Dictionary, line_count: int) -> Dictionary:
	var node := primary.get("node")
	var current: int = primary["next_ind"]

	while current < tokens.size():
		var skip: Dictionary = _skip_until([_SYMBOLS.NEW_LINE,
											_SYMBOLS.DOT,
											_SYMBOLS.PARENTHESIS,
											_SYMBOLS.SQUARED,
											_SYMBOLS.COMMA,
											_SYMBOLS.COLON], tokens, current, line_count)
		current = skip["next_ind"]
		line_count = skip["line_count"]

		if current >= tokens.size():
			break

		var token := tokens[current]
	
		if token.type == _SYMBOLS.DOT:
			current += 1
			var name: String = tokens[current].value
			node = ScriptAST.MemberAcessNode.new(line_count, node, ScriptAST.IdentifierNode.new(name))
			current += 1
			continue

		if token.type == _SYMBOLS.PARENTHESIS and token.value == "(":
			var call_node: Dictionary = _parse_function_call(tokens, current, line_count, node)
			node = call_node["node"]
			current = call_node["next_ind"]
			line_count = call_node["line_count"]
			continue

		if token.type == _SYMBOLS.SQUARED and token.value == "[":
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

func _is_valid_assign(node: AST.ASTNode) -> bool:
	return node.type != ScriptAST.NodeType.FUNC_CALL

func _parse_expression(tokens: Array[AST.Token], current: int, line_count: int, expects_assign: bool) -> Dictionary:
	var primary: Dictionary = _parse_primary(tokens, current, line_count)
	primary = _parse_postfix_chain(tokens, primary, primary["line_count"])

	expects_assign = expects_assign and _is_valid_assign(primary["node"])

	if expects_assign:
		var skip: Dictionary = _skip_until([_SYMBOLS.EQUAL], tokens, primary["next_ind"], primary["line_count"])
		current = skip["next_ind"]
		line_count = skip["line_count"]

		if current >= tokens.size():
			return primary

		var token := tokens[current]
	
		if token.type == _SYMBOLS.EQUAL:
			current += 1
			var parsed: Dictionary = _parse_expression(tokens, current, line_count, false)
			return {
				"node": ScriptAST.AssignmentNode.new(line_count, primary["node"], parsed["node"]),
				"next_ind": parsed["next_ind"],
				"line_count": parsed["line_count"]
			}

	return primary

func _parse_array(tokens: Array[AST.Token], current: int, line_count: int) -> Dictionary:
	var array_node := ScriptAST.ArrayNode.new([])
	current += 1

	while current < tokens.size():
		var token := tokens[current]

		if token.type == _SYMBOLS.NEW_LINE:
			line_count += 1
			current += 1
			continue

		if token.type == _SYMBOLS.SQUARED and token.value == "]":
			current += 1
			break

		if token.type == _SYMBOLS.COMMA \
			or token.type == _SYMBOLS.TABULATION:
			current += 1
			continue

		var expression: Dictionary = _parse_expression(tokens, current, line_count, false)
		array_node.value.append(expression["node"])
		current = expression["next_ind"]
		line_count = expression["line_count"]

	return {
		"node": array_node,
		"next_ind": current,
		"line_count": line_count
	}

func _parse_dictionary(tokens: Array[AST.Token], current: int, line_count: int) -> Dictionary:
	var dictionary_node := ScriptAST.DictionaryNode.new([])
	current += 1

	while current < tokens.size():
		var token := tokens[current]

		if token.type == _SYMBOLS.NEW_LINE:
			line_count += 1
			current += 1
			continue

		if token.type == _SYMBOLS.CURLY and token.value == "}":
			current += 1
			break

		if token.type == _SYMBOLS.COMMA \
			or token.type == _SYMBOLS.TABULATION:
			current += 1
			continue

		var pair: Dictionary = _parse_dict_pair(tokens, current, line_count)
		dictionary_node.value.append(pair["node"])
		current = pair["next_ind"]
		line_count = pair["line_count"]

	return {
		"node": dictionary_node,
		"next_ind": current,
		"line_count": line_count
	}

func _parse_dict_pair(tokens: Array[AST.Token], current: int, line_count: int) -> Dictionary:
	var dict_pair_node := ScriptAST.DictPairNode.new(line_count, null, null)

	var key_node: Dictionary = _parse_expression(tokens, current, line_count, false)
	dict_pair_node.key = key_node["node"]
	current = key_node["next_ind"]
	line_count = key_node["line_count"]

	while current < tokens.size():
		var token := tokens[current]

		if token.type == _SYMBOLS.NEW_LINE:
			line_count += 1
			current += 1
			continue

		if token.type == _SYMBOLS.COLON:
			current += 1
			break
	
		if token.type == _SYMBOLS.COMMA:
			return {
				"node": dict_pair_node,
				"next_ind": current,
				"line_count": line_count
			}
	
		current += 1

	var value_node: Dictionary = _parse_expression(tokens, current, line_count, false)
	dict_pair_node.value = value_node["node"]

	return {
		"node": dict_pair_node,
		"next_ind": value_node["next_ind"],
		"line_count": value_node["line_count"]
	}

func _parse_index(tokens: Array[AST.Token], current: int, line_count: int, node: AST.ASTNode) -> Dictionary:
	var index_node := ScriptAST.MemberAcessNode.new(line_count, node, null)
	current += 1

	while current < tokens.size():
		var token := tokens[current]

		if token.type == _SYMBOLS.NEW_LINE:
			line_count += 1
			current += 1
			continue

		if token.type == _SYMBOLS.SQUARED and token.value == "]":
			current += 1
			break

		var expression: Dictionary = _parse_expression(tokens, current, line_count, false)
		index_node.key = expression["node"]
		current = expression["next_ind"]
		line_count = expression["line_count"]

	return {
		"node": index_node,
		"next_ind": current,
		"line_count": line_count
	}

func _parse_function_call(tokens: Array[AST.Token], current: int, line_count: int, node: AST.ASTNode) -> Dictionary:
	var call_node := ScriptAST.CallNode.new(line_count, node, [])
	current += 1

	while current < tokens.size():
		var token := tokens[current]

		if token.type == _SYMBOLS.NEW_LINE:
			line_count += 1
			current += 1
			continue

		if token.type == _SYMBOLS.PARENTHESIS and token.value == ")":
			current += 1
			break

		if token.type == _SYMBOLS.COMMA \
			or token.type == _SYMBOLS.TABULATION:
			current += 1
			continue

		var expression: Dictionary = _parse_expression(tokens, current, line_count, false)
		call_node.args.append(expression["node"])
		current = expression["next_ind"]
		line_count = expression["line_count"]

	return {
		"node": call_node,
		"next_ind": current,
		"line_count": line_count
	}

func _parse_return_value(tokens: Array[AST.Token], current: int, line_count: int) -> Dictionary:
	var name := ScriptAST.IdentifierNode.new(tokens[current].value)
	current += 1

	var expression: Dictionary = _parse_expression(tokens, current, line_count, false)
	return {
		"node": ScriptAST.AssignmentNode.new(line_count, name, expression["node"]),
		"next_ind": expression["next_ind"],
		"line_count": expression["line_count"]
	}

func _parse_params(tokens: Array[AST.Token], current: int, line_count: int) -> Dictionary:
	var params: Array[ScriptAST.IdentifierNode] = []
	current += 1

	while current < tokens.size():
		var token := tokens[current]

		if token.type == _SYMBOLS.PARENTHESIS and token.value == ")":
			current += 1
			break

		if token.type == _SYMBOLS.COMMA:
			current += 1
			continue

		if token.type == _SYMBOLS.NAME:
			params.append(ScriptAST.IdentifierNode.new(token.value))

			var skip: Dictionary = _skip_until([_SYMBOLS.COMMA, _SYMBOLS.PARENTHESIS], tokens, current, line_count)
			current = skip["next_ind"]
			line_count = skip["line_count"]
			continue

		current += 1

	return {
		"node": params,
		"next_ind": current,
		"line_count": line_count
	}

func _parse_scope(tokens: Array[AST.Token], current: int, line_count: int, tab_count: int) -> Dictionary:
	var scope_node := ScriptAST.ScopeNode.new(line_count, [])

	var token := tokens[current]
	if token.type != _SYMBOLS.COLON:
		return {
			"node": scope_node,
			"next_ind": current,
			"line_count": line_count
		}

	current += 1
	if tokens[current].type != _SYMBOLS.NEW_LINE:
		var parsed: Dictionary = _parse_token(tokens, current, line_count, tab_count)
		if parsed.has("node"):
			scope_node.body.append(parsed["node"])

		return {
			"node": scope_node,
			"next_ind": parsed["next_ind"],
			"line_count": parsed["line_count"]
		}

	var inner_tabulation: int = tab_count + 1
	while current < tokens.size():
		token = tokens[current]

		if token.type != _SYMBOLS.NEW_LINE and token.type != _SYMBOLS.TABULATION:
			if inner_tabulation <= tab_count:
				break

		var parsed: Dictionary = _parse_token(tokens, current, line_count, inner_tabulation)
		if parsed.has("node"):
			scope_node.body.append(parsed["node"])

		current = parsed["next_ind"]
		line_count = parsed["line_count"]
		inner_tabulation = parsed.get("tab_count", inner_tabulation)
	
	return {
		"node": scope_node,
		"next_ind": current,
		"line_count": line_count
	}

func _parse_function_decl(tokens: Array[AST.Token], current: int, line_count: int, tab_count: int) -> Dictionary:
	var func_decl_node := ScriptAST.FuncDeclNode.new(line_count, null, [], ScriptAST.ScopeNode.new(line_count, []))
	current += 1

	var skip: Dictionary = _skip_until([_SYMBOLS.NEW_LINE, _SYMBOLS.NAME], tokens, current, line_count)
	current = skip["next_ind"]
	line_count = skip["line_count"]

	var token := tokens[current]
	if token.type == _SYMBOLS.NAME:
		func_decl_node.identifier = ScriptAST.IdentifierNode.new(token.value)
		current += 1

	skip = _skip_until([_SYMBOLS.PARENTHESIS], tokens, current, line_count)
	current = skip["next_ind"]
	line_count = skip["line_count"]

	token = tokens[current]
	if token.type == _SYMBOLS.PARENTHESIS and token.value == "(":
		var params: Dictionary = _parse_params(tokens, current, line_count)
		func_decl_node.params = params["node"]

		current = params["next_ind"]
		line_count = params["line_count"]

	skip = _skip_until([_SYMBOLS.NEW_LINE, _SYMBOLS.COLON], tokens, current, line_count)
	current = skip["next_ind"]
	line_count = skip["line_count"]

	var scope: Dictionary = _parse_scope(tokens, current, line_count, tab_count)
	func_decl_node.scope = scope["node"]

	return {
		"node": func_decl_node,
		"next_ind": scope["next_ind"],
		"line_count": scope["line_count"]
	}

func _parse_conditional(tokens: Array[AST.Token], current: int, line_count: int, tab_count: int) -> Dictionary:
	var skip: Dictionary = _skip_until([_SYMBOLS.NEW_LINE, _SYMBOLS.COLON], tokens, current, line_count)
	current = skip["next_ind"]
	line_count = skip["line_count"]

	var scope_node := _parse_scope(tokens, current, line_count, tab_count)

	return {
		"node": scope_node["node"],
		"next_ind": scope_node["next_ind"],
		"line_count": scope_node["line_count"]
	}

func _parse_for_loop(tokens: Array[AST.Token], current: int, line_count: int, tab_count: int) -> Dictionary:
	current += 1
	return {
		"node": ScriptAST.ScopeNode.new(line_count, []),
		"next_ind": current,
		"line_count": line_count
	}

func _parse_token(tokens: Array[AST.Token], current: int, line_count: int, tab_count: int) -> Dictionary:
	var token := tokens[current]

	match token.type:
		_SYMBOLS.CLASS_NAME: return _parse_class_name(tokens, current, line_count)
		_SYMBOLS.PARENT_CLASS: return _parse_parent_class(tokens, current, line_count)
		_SYMBOLS.VARIABLE: return _parse_variable(tokens, current, line_count)
		_SYMBOLS.FUNCTION: return _parse_function_decl(tokens, current, line_count, tab_count)
		_SYMBOLS.CONDITIONAL: return _parse_conditional(tokens, current, line_count, tab_count)
		_SYMBOLS.FOR_LOOP: return _parse_for_loop(tokens, current, line_count, tab_count)
		_SYMBOLS.NAME: return _parse_expression(tokens, current, line_count, true)
		_SYMBOLS.RETURNS: return _parse_return_value(tokens, current, line_count)
		#_SYMBOLS.ANNOTATION: return _ignore_annotation(tokens, current, line_count) # im changing this later on
		_SYMBOLS.IGNORE:
			return {
				"next_ind": current + 1,
				"line_count": line_count
			}
		_SYMBOLS.NEW_LINE, \
		_SYMBOLS.LINE_COMMENT:
			return {
				"next_ind": current + 1,
				"line_count": line_count + 1,
				"tab_count": 0
			}
		_SYMBOLS.TABULATION:
			return {
				"next_ind": current + 1,
				"line_count": line_count,
				"tab_count": tab_count + 1
			}
		_SYMBOLS.BACKSLASH:
			return {
				"next_ind": current + 2,
				"line_count": line_count + 1,
				"tab_count": 0
			}
		_: return _parse_literal(tokens, current, line_count)

func parse_script(tokens: Array[AST.Token]) -> ScriptAST.ScopeNode:
	var root: ScriptAST.ScopeNode = ScriptAST.ScopeNode.new(0, [])
	var line_count: int = 1
	var tab_count: int = 0

	var current: int = 0
	while current < tokens.size():
		var parsed: Dictionary = _parse_token(tokens, current, line_count, tab_count)
		if parsed.has("node"):
			root.body.append(parsed["node"])

		line_count = parsed["line_count"]
		tab_count = parsed.get("tab_count", tab_count)
		current = parsed["next_ind"]

	return root
