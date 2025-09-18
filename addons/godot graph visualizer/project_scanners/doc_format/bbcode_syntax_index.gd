@tool
extends Resource
class_name BBcodeSyntaxIndex

enum TagType {
	BOLD_OPENING,
	BOLD_CLOSING,
	ITALIC_OPENING,
	ITALIC_CLOSING,
	# ...
}

const _SYNTAX: Dictionary[TagType, String] = {
	TagType.BOLD_OPENING: "[b]",
	TagType.BOLD_CLOSING: "[/b]",
	TagType.ITALIC_OPENING: "[i]",
	TagType.ITALIC_CLOSING: "[/i]",
	# ...
}

static func get_tag(tag: TagType):
	return _SYNTAX[tag]
