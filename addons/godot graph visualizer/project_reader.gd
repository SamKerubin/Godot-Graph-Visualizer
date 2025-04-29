@tool
extends Node
class_name ProjectReader

var _scene_files: Array[String] = []
var _script_files: Array[String] = []
var _resource_files: Array[String] = []
var _text_files: Array[String] = []

func read_all_project() -> void:
	var dir: DirAccess = DirAccess.open("res://")
	if not dir:
		push_error("Error: No se ha encontrado el directorio principal")
		return
	
	dir.list_dir_begin()
	var file_name: String = dir.get_next()
	while file_name != "": pass

func get_scenes_in_project() -> Array[String]:
	return _scene_files

func get_scripts_in_project() -> Array[String]:
	return _script_files

func get_resources_in_proyect() -> Array[String]:
	return _resource_files

func get_text_files_in_proyect() -> Array[String]:
	return _text_files
