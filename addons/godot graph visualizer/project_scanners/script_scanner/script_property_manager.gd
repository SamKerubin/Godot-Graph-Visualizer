@tool
extends Resource
class_name ScriptPropertyManager

## Manager class made to read scripts properties[br]
## It search for things like:[br]
## - variables/constants[br]
## - methods[br][br]
## For reading all scripts, use: [method search_properties_in_all_scripts][br][br]
## For more information about properties, see: [class ScriptPropertyReference]

# Regexes
const _CLASS_DECLARATION_REFERENCE: String = r"^class_name\s+(\w+)"
const _VARIABLE_DECLARATION_REFERENCE: String = \
	r"(var|const)\s+(\w+)(?::\s*(?:[\w.]+" \
	+ r"(?:\s*[\s*[\w\s,]+\s*\])?))?\s*(?:(?::?=)\s*(.+))?"

## Holds all the saved properties of each script file[br]
## see [class ScriptPropertyReference]
var _script_properties: Dictionary[String, ScriptPropertyReference]

## Regex that will match with class names
var _class_regex: RegEx = RegEx.new()
## Regex that will match with variables
var _variable_regex: RegEx = RegEx.new()

func _init() -> void:
	"""
		Initialize the Regexes
	"""

	if _class_regex.compile(_CLASS_DECLARATION_REFERENCE) != OK:
		push_error("Error: Failed to compile class declaration regex")

	if _variable_regex.compile(_VARIABLE_DECLARATION_REFERENCE) != OK:
		push_error("Error: Failed to compile variable declaration regex")

#region Reading Scripts
## @experimental: This is still an uncomplete method
## Given a script file path, reads it and saves every property found[br]
## While reading, ignores comments like:[br][br]
## - #[br]
## - ##[br]
## - """ """[br]
## And complete lines that for example, declares arrays or dicts:[br]
## [gdscript]
## var dict: Dictionary = { # ... 
## } # <- Completes all the content
## [/gdscript]
func _read_file(path: String) -> void:
	""" 
	 """

	if not ResourceLoader.exists(path):
		push_error("Error: Invalid path \'%s\'" % path)
		return

	var script: FileAccess = FileAccess.open(path, FileAccess.READ)
	if not script:
		push_error("Error: Unable to open script \'%s\'" % path)
		return

	var result: ScriptPropertyReference = ScriptPropertyReference.new()
	while not script.eof_reached():
		var line: String = script.get_line()
		if line:
			# FIXME: This doesnt work 100% well, fix later
			if line.contains("#"):
				line = line.get_slice("#", 0)

			while line.ends_with("\\"):
				line = line.replace("\\", "")
				line += script.get_line().replace("\t", "")

			# FIXME: This crashes the editor, modify later
			#if line.ends_with("[") or line.ends_with("{"):
				#while line.count("]", 0, line.length() - 1) != 1 or line.count("}", 0, line.length() - 1) != 1:
					#line += script.get_line().replace("\t", "")

			result = _search_in_line(line, result)

	if result: _store_line(path, result)

	script.close()

## Search in a line of a script file for references[br]
## Matches the line with all regexes[br]
## If theres is any match, then saves it and return a new instance of
## [class ScriptPropertyReference]
func _search_in_line(line: String, script_property: ScriptPropertyReference) -> ScriptPropertyReference:
	var c_name: String = _match_class(line)

	var property_match: Array[String] = _match_property(line)
	var type: String = property_match[0]
	var value_name: String = property_match[1]
	var value: String = property_match[2]

	if c_name != "": script_property.set_class_name(c_name)

	if type == "var": script_property.add_var(value_name, value)
	elif type == "const": script_property.add_const(value_name, value)

	return script_property

## Store a new script property[br]
## If its already in the dictionary, then its not added
func _store_line(path: String, script: ScriptPropertyReference) -> void:
	if _script_properties.has(path): return

	_script_properties.set(path, script)

## Reads every script file inside the project[br]
## [param script_files] Holds every script file path inside the project
func search_properties_in_all_scripts(script_files: Array) -> void:
	_script_properties.clear()
	for scr: String in script_files:
		_read_file(scr)
#endregion

#region Matching Regex
## Uses regex [member _class_regex] to search for
## a class name inside the script[br]
## If it doesnt match anything, returns an empty string
func _match_class(line: String) -> String:
	var matches: RegExMatch = _class_regex.search(line)
	if matches: return matches.get_string(1)

	return ""

## Uses regex [member _variable_regex] to search
## for properties inside the script[br]
## If it doesnt match anything, returns an array with 3 slots
## with string value "null"
func _match_property(line: String) -> Array[String]:
	var matches: RegExMatch = _variable_regex.search(line)
	if matches:
		return [
			matches.get_string(1),
			matches.get_string(2),
			matches.get_string(3)
		]

	return ["null", "null", "null"]

# TODO: Include a method to add methods and variable scoping for each method added
#endregion

#region Get Script Property
## [param c_name] Refers to a class name[br]
## Search all the properties saved[br]
## Returns the first instance that matches the entered [param c_name]
func find_script_property_with_class(c_name: String) -> ScriptPropertyReference:
	for prop: ScriptPropertyReference in _script_properties.values():
		if prop.get_class_name() == c_name: return prop
	
	return null

## Returns the properties that are currently saved
func get_script_properties() -> Dictionary[String, ScriptPropertyReference]:
	return _script_properties
#endregion
