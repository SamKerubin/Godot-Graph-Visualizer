@tool
extends Resource
class_name ScriptSymbolIndex

enum SymbolType {
	NEW_LINE,
	TABULATION,
	LINE_COMMENT,
	ANNOTATION,
	EQUAL,
	SQUARED,
	PARENTHESIS,
	CURLY,
	COMMA,
	DOT,
	COLON,
	BACKSLASH,
	VARIABLE,
	CLASS_NAME,
	PARENT_CLASS,
	IGNORE,
	CONDITIONAL,
	FOR_LOOP,
	FOR_CONDITION,
	MATCH,
	FUNCTION,
	RETURNS,
	NAME,
	LITERAL
}

const _SYMBOL := {
	"\n": SymbolType.NEW_LINE,
	"\t": SymbolType.TABULATION,
	"@": SymbolType.ANNOTATION,
	"=": SymbolType.EQUAL,
	"[": SymbolType.SQUARED,
	"]": SymbolType.SQUARED,
	"(": SymbolType.PARENTHESIS,
	")": SymbolType.PARENTHESIS,
	"{": SymbolType.CURLY,
	"}": SymbolType.CURLY,
	",": SymbolType.COMMA,
	".": SymbolType.DOT,
	":": SymbolType.COLON,
	"\\": SymbolType.BACKSLASH,
	"var": SymbolType.VARIABLE,
	"const": SymbolType.VARIABLE,
	"class_name": SymbolType.CLASS_NAME,
	"extends": SymbolType.PARENT_CLASS,
	"continue": SymbolType.IGNORE,
	"break": SymbolType.IGNORE,
	"pass": SymbolType.IGNORE,
	"await": SymbolType.IGNORE,
	"signal": SymbolType.IGNORE,
	"->": SymbolType.IGNORE,
	"static": SymbolType.IGNORE,
	"if": SymbolType.CONDITIONAL,
	"elif": SymbolType.CONDITIONAL,
	"else": SymbolType.CONDITIONAL,
	"while": SymbolType.CONDITIONAL,
	"for": SymbolType.FOR_LOOP,
	"in": SymbolType.FOR_CONDITION, # specifically made to parse a for loop
	"match": SymbolType.MATCH,
	"func": SymbolType.FUNCTION,
	"return": SymbolType.RETURNS
}

static func get_symbol_type(entry: String) -> SymbolType:
	if entry.is_valid_int() or entry.is_valid_float():
		return SymbolType.LITERAL

	return _SYMBOL.get(entry, SymbolType.NAME)
