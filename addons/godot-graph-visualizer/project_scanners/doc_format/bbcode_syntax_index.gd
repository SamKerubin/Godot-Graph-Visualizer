@tool
extends Resource
class_name BBCodeSyntaxIndex

enum TagType {
	ROOT,
	TEXT,
	INLINE,
	LINE,
	BLOCK
}

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
		"type": TagType.INLINE
	},
	"#": {
		"bbcode_open": "[b][font_size=%d]" % _HEADING1_SIZE,
		"bbcode_close": "[/font_size][/b]",
		"type": TagType.LINE
	},
	"h2": {
		"bbcode_open": "[b][font_size=%d]" % _HEADING2_SIZE,
		"bbcode_close": "[/font_size][/b]",
		"type": TagType.INLINE
	},
	"##": {
		"bbcode_open": "[b][font_size=%d]" % _HEADING2_SIZE,
		"bbcode_close": "[/font_size][/b]",
		"type": TagType.LINE
	},
	"h3": {
		"bbcode_open": "[b][font_size=%d]" % _HEADING3_SIZE,
		"bbcode_close": "[/font_size][/b]",
		"type": TagType.INLINE
	},
	"###": {
		"bbcode_open": "[b][font_size=%d]" % _HEADING3_SIZE,
		"bbcode_close": "[/font_size][/b]",
		"type": TagType.LINE
	},
	"h4": {
		"bbcode_open": "[b][font_size=%d]" % _HEADING4_SIZE,
		"bbcode_close": "[/font_size][/b]",
		"type": TagType.INLINE
	},
	"####": {
		"bbcode_open": "[b][font_size=%d]" % _HEADING4_SIZE,
		"bbcode_close": "[/font_size][/b]",
		"type": TagType.LINE
	},
	"h5": {
		"bbcode_open": "[b][font_size=%d]" % _HEADING5_SIZE,
		"bbcode_close": "[/font_size][/b]",
		"type": TagType.INLINE
	},
	"#####": {
		"bbcode_open": "[b][font_size=%d]" % _HEADING5_SIZE,
		"bbcode_close": "[/font_size][/b]",
		"type": TagType.LINE
	},
	"h6": {
		"bbcode_open": "[b][font_size=%d]" % _HEADING6_SIZE,
		"bbcode_close": "[/font_size][/b]",
		"type": TagType.INLINE
	},
	"######": {
		"bbcode_open": "[b][font_size=%d]" % _HEADING6_SIZE,
		"bbcode_close": "[/font_size][/b]",
		"type": TagType.LINE
	},
	"i": {
		"bbcode_open": "[i]",
		"bbcode_close": "[/i]",
		"type": TagType.INLINE
	},
	"_": {
		"bbcode_open": "[i]",
		"bbcode_close": "[/i]",
		"type": TagType.INLINE
	},
	"*": {
		"bbcode_open": "[i]",
		"bbcode_close": "[/i]",
		"type": TagType.INLINE
	},
	"b": {
		"bbcode_open": "[b]",
		"bbcode_close": "[/b]",
		"type": TagType.INLINE
	},
	"**": {
		"bbcode_open": "[b]",
		"bbcode_close": "[/b]",
		"type": TagType.INLINE
	},
	"u": {
		"bbcode_open": "[u]",
		"bbcode_close": "[/u]",
		"type": TagType.INLINE
	},
	"s": {
		"bbcode_open": "[s]",
		"bbcode_close": "[/s]",
		"type": TagType.INLINE
	},
	"~~": {
		"bbcode_open": "[s]",
		"bbcode_close": "[/s]",
		"type": TagType.INLINE
	},
	"quote": {
		"bbcode_open": "\t[color=white]",
		"bbcode_close": "[/color]",
		"type": TagType.INLINE
	},
	"blockquote": {
		"bbcode_open": "\t[color=white]",
		"bbcode_close": "[/color]",
		"type": TagType.INLINE
	},
	">": {
		"bbcode_open": "\t[color=white]",
		"bbcode_close": "[/color]",
		"type": TagType.LINE
	},
	"code": {
		"bbcode_open": "[code]",
		"bbcode_close": "[/code]",
		"type": TagType.INLINE
	},
	"`": {
		"bbcode_open": "[code]",
		"bbcode_close": "[/code]",
		"type": TagType.INLINE
	},
	"```": {
		"bbcode_open": "[code]",
		"bbcode_close": "[/code]",
		"type": TagType.BLOCK
	}
	#...
}
#endregion

static func get_tag_type(tag: String) -> TagType:
	return _SYNTAX.get(tag, {}).get("type", TagType.INLINE)

static func get_bbcode_open_tag(tag: String) -> String:
	return _SYNTAX.get(tag, {}).get("bbcode_open", "") 

static func get_bbcode_close_tag(tag: String) -> String:
	return _SYNTAX.get(tag, {}).get("bbcode_close", "")

static func has_tag(tag: String) -> bool:
	return not _SYNTAX.get(tag, "").is_empty()
