@tool
extends Resource
class_name ScriptPropertyManager

signal property_created(path: String, property: ScriptPropertyReference)

const CLASS_DECLARATION_REFERENCE: String = r"^class_name\s+(\w+)"
const VARIABLE_DECLARATION_REFERENCE: String = \
	r"(var|const)\s+(\w+)(?::\s*(?:[\w.]+(?:\s*\[\s*[\w\s,]+\s*\])?))?\s*(?:(?::?=)\s*(.+))?"

var _script_properties: Dictionary[String, ScriptPropertyReference]

var _class_regex: RegEx = RegEx.new()
var _variable_regex: RegEx = RegEx.new()

func _ready() -> void:
	_class_regex.compile(CLASS_DECLARATION_REFERENCE)
	_variable_regex.compile(VARIABLE_DECLARATION_REFERENCE)

#region Reading Scripts
func _read_file(path: String) -> void:
	if not ResourceLoader.exists(path):
		push_error("Error: Invalid path \'%s\'" % path)
		return

	var script: FileAccess = FileAccess.open(path, FileAccess.READ)
	if not script:
		push_error("Error: Unable to open script \'%s\'" % path)
		return

	while not script.eof_reached():
		var line: String = script.get_line()
		if line:
			if line.contains("#"):
				line = line.get_slice("#", 0)

			while line.ends_with("\\"):
				line = line.replace("\\", "")
				line += script.get_line().replace("\t", "")

			var result: ScriptPropertyReference = _search_in_line(line, path)

			if result: _store_line(path, result)

	script.close()

func _search_in_line(line: String, path: String) -> ScriptPropertyReference:
	var c_name: String = _match_class(line)

	var property_match: Array[String] = _match_property(line)
	var type: String = property_match[0]
	var value_name: String = property_match[1]
	var value: String = property_match[2]

	var script_property: ScriptPropertyReference = ScriptPropertyReference.new()

	if c_name != "": script_property.set_class_name(c_name)

	if type == "var": script_property.add_var(value_name, value)
	elif type == "const": script_property.add_const(value_name, value)

	property_created.emit(path, script_property)

	return script_property

func _store_line(path: String, script: ScriptPropertyReference) -> void:
	if _script_properties.has(path): return

	_script_properties.set(path, script)

func _match_class(line: String) -> String:
	var matches: RegExMatch = _class_regex.search(line)
	if matches: return matches.get_string(1)

	return ""

func _match_property(line: String) -> Array[String]:
	var matches: RegExMatch = _variable_regex.search(line)
	if matches:
		return [
			matches.get_string(1),
			matches.get_string(2),
			matches.get_string(3)
		]

	return ["", "", ""]

func search_properties_in_all_scripts() -> void:
	var scripts: Array = FileScanner.get_files_by_type(FileTypes.FileType.SCRIPT_FILE)
	for scr: String in scripts:
		_read_file(scr)
#endregion

#region Get Script Property
func get_script_properties() -> Dictionary[String, ScriptPropertyReference]:
	return _script_properties
#endregion
