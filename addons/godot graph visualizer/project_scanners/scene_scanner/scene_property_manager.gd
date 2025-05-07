@tool
extends Node

signal initialize

const TEMP_FILE_PATH: String = "user://temp_file.tscn"

var _scene_properties: Array[SceneData]

func _check_scene(path: String) -> void:
	if not ResourceLoader.exists(path):
		push_error("Error: Invalid path \'%s\'" % path)
		return

	var scn: PackedScene = ResourceLoader.load(path, "PackedScene")

	var scn_root: Node = scn.instantiate()

	var scene_data: SceneData = _search_in_scene(scn_root, path)
	if scene_data: _store_line(scene_data)

	scn_root.free()

func _search_in_scene(scn: Node, path: String) -> SceneData:
	var scene_data: SceneData = find_scene_with_path(path)
	if not scene_data: scene_data = SceneData.new(path)

	var script_data: ScriptData = _search_attached_script(scn)
	if script_data: scene_data.get_properties().set_attached_script(script_data)

	var instances: Array[SceneData] = _search_instances(scn)
	for inst: SceneData in instances:
		scene_data.get_properties().add_instance(inst)

	return scene_data

func _search_attached_script(scn: Node) -> ScriptData:
	var script: Script = scn.get_script()
	if not script: return null

	var script_data_path: String = script.resource_path
	var script_data: ScriptData = ScriptPropertyManager.find_script_with_path(script_data_path)

	return script_data

func _search_instances(scn: Node) -> Array[SceneData]:
	var instances: Array[SceneData] = []
	for child: Node in scn.get_children():
		if child is Node:
			if child.scene_file_path != "":
				var new_scene: SceneData = find_scene_with_path(child.scene_file_path)
				if not new_scene: new_scene = SceneData.new(child.scene_file_path)
				instances.append(new_scene)

			instances += _search_instances(child)

	return instances

func _store_line(scene: SceneData) -> void:
	if _scene_properties.has(scene): return

	_scene_properties.append(scene)

func search_properties_in_all_scenes() -> void:
	var scenes: Array = FileScanner.get_files_by_type(FileTypes.FileType.SCENE_FILE)
	for scn: String in scenes:
		_check_scene(scn)

	initialize.emit()

func find_scene_with_path(path: String) -> SceneData:
	for scn: SceneData in _scene_properties:
		if scn.get_node_path() == path or scn.get_uid_text() == path:
			return scn

	return null

func get_scenes_properties() -> Array[SceneData]:
	return _scene_properties
