@tool
extends Resource
class_name BBCodeSyntaxIndex

const _HEADING1_SIZE := 45
const _HEADING2_SIZE := 40
const _HEADING3_SIZE := 35
const _HEADING4_SIZE := 30
const _HEADING5_SIZE := 25
const _HEADING6_SIZE := 20

const _SYNTAX := {
	"h1": {
		"bbcode_open": "[font_size=%d]" % _HEADING1_SIZE,
		"bbcode_close": "[/font_size]",
		"name": "heading1",
		"type": "line"
	},
	"#": {
		"bbcode_open": "[font_size=%d]" % _HEADING1_SIZE,
		"bbcode_close": "[/font_size]",
		"name": "heading1",
		"type": "line"
	},
	"i": {
		"bbcode_open": "[i]",
		"bbcode_close": "[/i]",
		"name": "italic",
		"type": "inline"
	},
	"_": {
		"bbcode_open": "[i]",
		"bbcode_close": "[/i]",
		"name": "italic",
		"type": "inline"
	},
	"*": {
		"bbcode_open": "[i]",
		"bbcode_close": "[/i]",
		"name": "italic",
		"type": "inline"
	},
	"b": {
		"bbcode_open": "[b]",
		"bbcode_close": "[/b]",
		"name": "bold",
		"type": "inline"
	},
	"**": {
		"bbcode_open": "[b]",
		"bbcode_close": "[/b]",
		"name": "bold",
		"type": "inline"
	},
	"***": {
		"bbcode_open": "[i][b]",
		"bbcode_close": "[/b][/i]",
		"name": "bold-italic",
		"type": "inline"
	},
	#...
}

static func get_tag_name(tag: String) -> String:
	return _SYNTAX.get(tag, {}).get("name", "unknown")

static func get_tag_type(tag: String) -> String:
	return _SYNTAX.get(tag, {}).get("type", "inline")

static func get_bbcode_tag(tag: String, closing: bool=false) -> String:
	if closing:
		return _SYNTAX.get(tag, {}).get("bbcode_close", "")

	return _SYNTAX.get(tag, {}).get("bbcode_open", "") 

static func has_tag(tag: String) -> bool:
	return not _SYNTAX.get(tag, "").is_empty()
