@tool
extends Resource
class_name BBCodeSyntaxIndex

const _HEADING1_SIZE := 45
const _HEADING2_SIZE := 40
const _HEADING3_SIZE := 35
const _HEADING4_SIZE := 30
const _HEADING5_SIZE := 25
const _HEADING6_SIZE := 20

#region Syntax
const _SYNTAX := {
	"h1": {
		"bbcode_open": "[b][font_size=%d]" % _HEADING1_SIZE,
		"bbcode_close": "[/font_size][/b]",
		"type": "inline"
	},
	"#": {
		"bbcode_open": "[b][font_size=%d]" % _HEADING1_SIZE,
		"bbcode_close": "[/font_size][/b]",
		"type": "line"
	},
	"h2": {
		"bbcode_open": "[b][font_size=%d]" % _HEADING2_SIZE,
		"bbcode_close": "[/font_size][/b]",
		"type": "inline"
	},
	"##": {
		"bbcode_open": "[b][font_size=%d]" % _HEADING2_SIZE,
		"bbcode_close": "[/font_size][/b]",
		"type": "line"
	},
	"h3": {
		"bbcode_open": "[b][font_size=%d]" % _HEADING3_SIZE,
		"bbcode_close": "[/font_size][/b]",
		"type": "inline"
	},
	"###": {
		"bbcode_open": "[b][font_size=%d]" % _HEADING3_SIZE,
		"bbcode_close": "[/font_size][/b]",
		"type": "line"
	},
	"h4": {
		"bbcode_open": "[b][font_size=%d]" % _HEADING4_SIZE,
		"bbcode_close": "[/font_size][/b]",
		"type": "inline"
	},
	"####": {
		"bbcode_open": "[b][font_size=%d]" % _HEADING4_SIZE,
		"bbcode_close": "[/font_size][/b]",
		"type": "line"
	},
	"h5": {
		"bbcode_open": "[b][font_size=%d]" % _HEADING5_SIZE,
		"bbcode_close": "[/font_size][/b]",
		"type": "inline"
	},
	"#####": {
		"bbcode_open": "[b][font_size=%d]" % _HEADING5_SIZE,
		"bbcode_close": "[/font_size][/b]",
		"type": "line"
	},
	"h6": {
		"bbcode_open": "[b][font_size=%d]" % _HEADING6_SIZE,
		"bbcode_close": "[/font_size][/b]",
		"type": "inline"
	},
	"######": {
		"bbcode_open": "[b][font_size=%d]" % _HEADING6_SIZE,
		"bbcode_close": "[/font_size][/b]",
		"type": "line"
	},
	"i": {
		"bbcode_open": "[i]",
		"bbcode_close": "[/i]",
		"type": "inline"
	},
	"_": {
		"bbcode_open": "[i]",
		"bbcode_close": "[/i]",
		"type": "inline"
	},
	"*": {
		"bbcode_open": "[i]",
		"bbcode_close": "[/i]",
		"type": "inline"
	},
	"b": {
		"bbcode_open": "[b]",
		"bbcode_close": "[/b]",
		"type": "inline"
	},
	"**": {
		"bbcode_open": "[b]",
		"bbcode_close": "[/b]",
		"type": "inline"
	},
	"u": {
		"bbcode_open": "[u]",
		"bbcode_close": "[/u]",
		"type": "inline"
	},
	"s": {
		"bbcode_open": "[s]",
		"bbcode_close": "[/s]",
		"type": "inline"
	},
	"~~": {
		"bbcode_open": "[s]",
		"bbcode_close": "[/s]",
		"type": "inline"
	},
	"quote": {
		"bbcode_open": "\t[color=white]",
		"bbcode_close": "[/color]",
		"type": "inline"
	},
	"blockquote": {
		"bbcode_open": "\t[color=white]",
		"bbcode_close": "[/color]",
		"type": "inline"
	},
	">": {
		"bbcode_open": "\t[color=white]",
		"bbcode_close": "[/color]",
		"type": "line"
	},
	"code": {
		"bbcode_open": "[code]",
		"bbcode_close": "[/code]",
		"type": "inline"
	},
	"`": {
		"bbcode_open": "[code]",
		"bbcode_close": "[/code]",
		"type": "inline"
	},
	"```": {
		"bbcode_open": "[code]",
		"bbcode_close": "[/code]",
		"type": "block"
	}
	#...
}
#endregion

static func get_tag_type(tag: String) -> String:
	return _SYNTAX.get(tag, {}).get("type", "inline")

static func get_bbcode_open_tag(tag: String) -> String:
	return _SYNTAX.get(tag, {}).get("bbcode_open", "") 

static func get_bbcode_close_tag(tag: String) -> String:
	return _SYNTAX.get(tag, {}).get("bbcode_close", "")

static func has_tag(tag: String) -> bool:
	return not _SYNTAX.get(tag, "").is_empty()
