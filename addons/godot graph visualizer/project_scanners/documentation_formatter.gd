@tool
extends Resource
class_name DocumentationFormatter

## Class for formatting doc strings
## It supports:[br]
## - BBcode (by default)[br]
## - Markdown (later)[br]
## - HTML (later)[br]

func format_text(text: String) -> String:
	if text.is_empty():
		return "This scene does not have a provided description within the property \'Editor Description\'"

	var text_formatted: String = ""
	var splitted_text: PackedStringArray = text.split("\n")
	for line: String in splitted_text:
		text_formatted += _format_line(line) + "\n"

	return text_formatted

func _format_line(line: String) -> String:
	var opening_tags: TagQueue = TagQueue.new()
	var string_literal: String = ""
	var closing_tags: TagQueue = TagQueue.new()

	for c in line:
		pass

	# OPTION 1:
	#     Uses regexes to get every tag in the line
	# OPTION 2: -- This seems more useful for nested tags
	#     Iterate over the entire string searching for the tags
	# Adds each tag to a queue
	# Queue 1 -> Opening tags
	# Queue 2 -> Closing tags
	# Takes the string literal
	# Empties the queue 1 formatting it with bbcode syntax
	# Places the string literal
	# Empties the queue 2 formatting it with bbcode syntax
	return ""
