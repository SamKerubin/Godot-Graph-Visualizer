@tool
extends Node
## @experimental: This class is being used to test
class_name ScriptParser

const PRELOAD_RERERENCE: String = "preload\\(\\s*(\"(?:(?:uid|res)://[^\"]+\"|\\s+(%s))\\s*\\)"
const LOAD_REFERENCE: String = "load\\(\\s*(\"(?:(?:uid|res)://[^\"]+\"|\\s+(%s))\\s*\\)"
const INSTANTIATE_REFERENCE: String = \
	"(?:(?:load|preload)\\(\\s*\"(?:(?:uid|res)://[^\"]+)\"\\s*\\)|\\b\\w+)\\.instantiate\\(\\)"
const NEW_RESOURCE_REFERENCE: String = "\\b(\\w+)\\.new\\(\\)"
const VARIABLE_REFERENCE: String = \
	"(?:var|const)\\s+(%s)\\s*=\\s*(?:load|preload)\\(\\s*\"((?:uid|res)://[^\"]+)\"\\s*\\)"

enum ReferenceType {
	PRELOAD_REFERENCE,
	LOAD_REFERENCE,
	INSTANCE_REFERENCE,
	NEW_RESOURCE_REFERENCE,
	NULL_REFERENCE
}

func parse_script(path: String) -> Dictionary[ReferenceType, Array]:
	var script: FileAccess = FileAccess.open(path, FileAccess.READ)
	if not script:
		push_error("Error: Failed to load \'%s\' file" % path)
		return { ReferenceType.NULL_REFERENCE: [] }

	var preload_pattern: RegEx = RegEx.new()
	preload_pattern.compile(PRELOAD_RERERENCE)
	var load_pattern: RegEx = RegEx.new()
	load_pattern.compile(LOAD_REFERENCE)
	var instance_pattern: RegEx = RegEx.new()
	instance_pattern.compile(INSTANTIATE_REFERENCE)
	var new_resource_pattern: RegEx = RegEx.new()
	new_resource_pattern.compile(NEW_RESOURCE_REFERENCE)

	var matches: Dictionary[ReferenceType, Array] = {}
	var line: String = script.get_line()
	while line:
		if line == "\n":
			line = script.get_line()
			continue

		var preload_matches: Array[RegExMatch] = preload_pattern.search_all(line)
		var load_matches: Array[RegExMatch] = load_pattern.search_all(line)
		var instance_matches: Array[RegExMatch] = instance_pattern.search_all(line)
		var new_resource_matches: Array[RegExMatch] = new_resource_pattern.search_all(line)

		line = script.get_line()
	
	return matches
