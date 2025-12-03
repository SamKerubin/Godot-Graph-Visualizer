@tool
extends Resource
class_name ScriptReferenceManager

var _script_properties: ScriptPropertiesManager
var _scripts: Array[ScriptData]

func _init() -> void:
	_script_properties = ScriptPropertiesManager.new()
	_scripts = []

func _get_script_content(path: String) -> String:
	var script: FileAccess = FileAccess.open(path, FileAccess.READ)
	if not script:
		push_error("Error: Unable to open '%s'" % path)
		return ""

	var content: String = script.get_as_text()
	script.close()
	return content

func find_script_with_path(path: String) -> ScriptData:
	for scr: ScriptData in _scripts:
		if scr.get_node_path() == path or scr.get_node_uid() == path:
			return scr

	return null

func print_child(child: AST.ASTNode) -> String:
	if not child:
		return "null"
	var c: String = ""
	if child is ScriptAST.VarDeclNode:
		c = "%d:var %s = %s" % [child.line, print_child(child.identifier), print_child(child.expression)]
	elif child is ScriptAST.IdentifierNode:
		c = "%s" % child.name
	elif child is ScriptAST.AssignmentNode:
		c = "%d:%s = %s" % [child.line, print_child(child.target), print_child(child.expression)]
	elif child is ScriptAST.CallNode:
		c = "%s(" % print_child(child.callable)
		for sub_c in child.args:
			c += "%s, " % print_child(sub_c)
		c += ")"
	elif child is ScriptAST.MemberAcessNode:
		c = "%s.%s" % [print_child(child.source), print_child(child.key)]
	elif child is ScriptAST.ArrayNode:
		c = "["
		for sub_c in child.value:
			c += "%s, " % print_child(sub_c)
	elif child is ScriptAST.DictionaryNode:
		c = "{"
		for sub_c in child.value:
			c += "%s, " % print_child(sub_c)
		c += "}"
	elif child is ScriptAST.DictPairNode:
		c = "%s: %s" % [print_child(child.key), print_child(child.value)]
	elif child is ScriptAST.LiteralNode:
		c = str(child.value)
	elif child is ScriptAST.ScriptPropertyNode:
		c = "prop -> %s" % print_child(child.identifier)
	elif child is ScriptAST.FuncDeclNode:
		c = "func %s(" % print_child(child.identifier)
		for sub_c in child.params:
			c += "%s, " % print_child(sub_c)
		c += ")"
	else:
		c = str(child.type)

	return c

func printAST(ast_root: ScriptAST.ScopeNode) -> void:
	for child: AST.ASTNode in ast_root.body:
		print(print_child(child))

func build_all_references(script_paths: Array) -> void:
	_scripts.clear()
	var script_tokenizer: ScriptTokenizer = ScriptTokenizer.new()
	var script_parser: ScriptParser = ScriptParser.new()
	var script_property_builder: ScriptPropertyBuilder = ScriptPropertyBuilder.new()
	
	var i := 0
	for path: String in script_paths:
		var content: String = _get_script_content(path)
		if content.is_empty():
			continue

		var tokens: Array[AST.Token] = script_tokenizer.tokenize(content)
		var ast_root: AST.ASTNode = script_parser.parse_script(tokens)
		print(path)
		printAST(ast_root)
		var parsed_script: ScriptProperty = script_property_builder.build_property(ast_root)
		_script_properties.add_script_to_database(path, parsed_script)
		i+=1

	var script_properties: Dictionary[String, ScriptProperty] = _script_properties.get_all_scripts()
	var reference_builder: ReferenceBuilder = ReferenceBuilder.new(_script_properties)
	for path: String in script_properties.keys():
		var property: ScriptProperty = script_properties[path]
		var script_reference: ScriptData = reference_builder.build_reference(path, property)
		_scripts.append(script_reference)
