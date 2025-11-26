@tool
extends Resource
class_name ScriptSymbolIndex

const _SYMBOL := {
	"\n": "new_line",
	"\t": "tabulation",
	"=": "equal",
	"[": "open_squared",
	"]": "closed_squared",
	"(": "open_parenthesis",
	")": "closed_parenthesis",
	"{": "open_curly",
	"}": "closed_curly",
	",": "comma",
	".": "dot",
	":": "colon",
	"var": "variable",
	"const": "constant",
	"class_name": "class_name",
	"extends": "parent_class",
	"if": "conditional",
	"while": "loop",
	"for": "loop",
	"return": "returns"
}

static func get_symbol_type(entry: String) -> String:
	if entry.is_valid_int() or entry.is_valid_float():
		return "number"

	return _SYMBOL.get(entry, "name")
