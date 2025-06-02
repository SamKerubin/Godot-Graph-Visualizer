@tool
extends Resource
class_name ScenePropertyManager

var _script_parser_manager: ScriptParserManager

var _scene_properties: Array[SceneData]

func _init() -> void:
	_script_parser_manager = ScriptParserManager.new()

#region Scene Reading
func _check_scene(path: String) -> void:
	if find_scene_with_path(path): return

	if not ResourceLoader.exists(path):
		push_error("Error: Invalid path \'%s\'" % path)
		return

	var scn: PackedScene = ResourceLoader.load(path, "PackedScene")
	var scn_root: Node = scn.instantiate()

	var scene_data: SceneData = _search_in_scene(scn_root, path)
	if scene_data: _scene_properties.append(scene_data)

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
	var script_data: ScriptData = _script_parser_manager.find_script_with_path(script_data_path)

	return script_data

func _search_instances(scene_data: SceneData, scn: Node) -> void:
	if scn.get_children().is_empty(): return

	for child: Node in scn.get_children():
		if child.scene_file_path != "":
			var child_path: String = child.scene_file_path
			var new_scene: SceneData = find_scene_with_path(child_path)
			if not new_scene:
				new_scene = SceneData.new(child_path)
				_scene_properties.append(new_scene)

			scene_data.get_properties().add_instance(child_path)

			_search_instances(new_scene, child)

			_search_instances(new_scene, child)
			continue

		_search_instances(scene_data, child)

func search_properties_in_all_scenes(script_files: Array, scene_files: Array) -> void:
	_scene_properties.clear()
	_script_parser_manager.parse_all_scripts(script_files)
	for scn: String in scene_files:
		_check_scene(scn)
#endregion

#region Get Scene Property
func find_scene_with_path(path: String) -> SceneData:
	for scn: SceneData in _scene_properties:
		if scn.get_node_path() == path or scn.get_node_uid() == path:
			return scn
	
	return null

func get_scenes_properties() -> Array[SceneData]:
	return _scene_properties

func get_parsed_scripts() -> ScriptParserManager:
	return _script_parser_manager
#endregion
