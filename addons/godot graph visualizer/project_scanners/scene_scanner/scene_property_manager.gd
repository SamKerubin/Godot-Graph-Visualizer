@tool
extends Node

signal initialize

var _scene_properties: Array[SceneData]

#region Scene Reading
func _check_scene(path: String) -> void:
	if find_scene_with_path(path): return

	if not ResourceLoader.exists(path):
		push_error("Error: Invalid path \'%s\'" % path)
		return

	var scn: PackedScene = ResourceLoader.load(path, "PackedScene")

	var scn_root: Node = scn.instantiate()

	var scene_data: SceneData = _search_in_scene(scn_root, path)
	if scene_data: _update_scene_property(scene_data)

	_search_instances(scene_data, scn_root)

	scn_root.free()

func _search_in_scene(scn: Node, path: String) -> SceneData:
	var scene_data: SceneData = find_scene_with_path(path)
	if not scene_data: scene_data = SceneData.new(path)

	var script_data: ScriptData = _search_attached_script(scn)
	if script_data: scene_data.get_properties().set_attached_script(script_data)

	return scene_data

func _search_attached_script(scn: Node) -> ScriptData:
	var script: Script = scn.get_script()
	if not script: return null

	var script_data_path: String = script.resource_path
	var script_data: ScriptData = ScriptPropertyManager.find_script_with_path(script_data_path)

	return script_data

func _search_instances(scene_data: SceneData, scn: Node) -> void:
	if scn.get_children().is_empty(): return

	for child: Node in scn.get_children():
		if child.scene_file_path != "":
			var new_scene: SceneData = find_scene_with_path(child.scene_file_path)
			if not new_scene: new_scene = SceneData.new(child.scene_file_path)

			scene_data.get_properties().add_instance(new_scene)
			_update_scene_property(new_scene)

			_search_instances(new_scene, child)
			continue

		_search_instances(scene_data, child)

func _update_scene_property(scene_data: SceneData) -> void:
	if not _scene_properties.has(scene_data):
		_scene_properties.append(scene_data)
		return

	var scene_index: int = _scene_properties.find(scene_data)
	_scene_properties.set(scene_index, scene_data)

func search_properties_in_all_scenes() -> void:
	var scenes: Array = FileScanner.get_files_by_type(FileTypes.FileType.SCENE_FILE)
	for scn: String in scenes:
		_check_scene(scn)

	initialize.emit()
#endregion

#region Get Scene Property
func find_scene_with_path(path: String) -> SceneData:
	for scn: SceneData in _scene_properties:
		if scn.get_node_path() == path or scn.get_uid_text() == path:
			return scn

	return null

func get_scenes_properties() -> Array[SceneData]:
	return _scene_properties
#endregion
