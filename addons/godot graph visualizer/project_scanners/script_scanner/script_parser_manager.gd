@tool
extends Node

signal initialize

const SCENE_REFERENCE: String = "" # preload|load(path).instantiate() <-- instantiate as optional
const INSTANTIATE_REFERENCE: String = \
	r"(?:(?:load|preload)\(\s*\"(?:(?:uid|res)://[^\"]+)\"\s*\)|\b\w+)\.instantiate\(\)"

var _scene_reference_regex: RegEx = RegEx.new()

var _parsed_scripts: Array[ScriptParsedReference]

func _ready() -> void:
	_scene_reference_regex.compile(SCENE_REFERENCE)

func _parse_script(script: ScriptData) -> void:
	var script_vars: Dictionary[String, String] = script.serialize()["var"]
	var script_consts: Dictionary[String, String] = script.serialize()["const"]

	var missing_properties: Dictionary[String, String] = script_vars
	missing_properties.merge(script_consts)
	for property: String in missing_properties:
		var value: String = missing_properties[property]

		var matches: Array[String] = _match_property(value, script)

	var parsed_script: ScriptParsedReference = ScriptParsedReference.new()

	_parsed_scripts.append(parsed_script)

func _match_property(property: String, script: ScriptData) -> Array[String]:
	var matches: RegExMatch = _scene_reference_regex.search(property)
	if not matches: return ["", "", ""]

	var type: String = matches.get_string(1)
	var path: String = matches.get_string(2)
	var instance: String = ""

	if matches.strings.size() > 3:
		instance = matches.get_string(3)

	if type != "load" or type != "preload":
		type = _find_value(type, script)

	if not path.is_absolute_path():
		path = _find_value(path, script)
	
	return [type, path, instance]

func _find_value(val: String, source: ScriptData) -> String:
	var splitted_value: PackedStringArray = val.split(".")
	var actual_value: String = splitted_value[0]
	while actual_value != splitted_value[-1]: pass
	# Search in soucre splitting the whole string by dots (.)
	# While val not last value:
	# If not in source:
	# Search if a class with that name exists
	# If the class doesnt exists, dont return anything
	# . . .
	# If in source:
	# Search next value ...
	
	# For example:
	# A.b.c
	# Search if A is a property ->
	# if is not -> search the class name
	# if class name is found -> go to class A as source and continue with the next value (b)
	# if class A contains b as property -> return b.get(c) (suposing b is dictionary)
	# If not found anything...
	# |
	# |
	return ""

func parse_all_scripts() -> void:
	var scripts: Array[ScriptData] = ScriptPropertyManager.get_scripts_properties()
	for scr in scripts:
		_parse_script(scr)

	initialize.emit()

func get_parsed_scripts() -> Array[ScriptParsedReference]:
	return _parsed_scripts
