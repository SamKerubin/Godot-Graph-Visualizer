@tool
extends Resource
class_name ScenePropertyManager

## Manager class made to parse properties inside a scene
## To understand what is considered as 'property' in this context,
## see [class ScenePropertyReference]

var _script_parser_manager: ScriptParserManager

## Holds the parsed scenes properties in an array of [class SceneData]
var _scene_properties: Array[SceneData]

func _init() -> void:
	"""
		Initialize the parsers
	"""

	_script_parser_manager = ScriptParserManager.new()

func _open_scene(path: String) -> Node:
	var scn: PackedScene = ResourceLoader.load(path, "PackedScene")
	return scn.instantiate()

#region Scene Matching
## Given a [param path], opens the scene file
## and search for each direct instance (child)
## the scene have
func _check_scene(path: String) -> void:
	if find_scene_with_path(path):
		return

	if not ResourceLoader.exists(path):
		push_error("Error: Invalid path \'%s\'" % path)
		return

	var scn_root: Node = _open_scene(path)

	var scene_data: SceneData = _search_in_scene(scn_root, path)
	_scene_properties.append(scene_data)

	_search_instances(scene_data, scn_root.get_children())
	scn_root.free()

## Using a scene [param scn] and its [param path],
## returns a [class SceneData] instance
func _search_in_scene(scn: Node, path: String) -> SceneData:
	var scene_data: SceneData = find_scene_with_path(path)
	if not scene_data:
		scene_data = SceneData.new(path)

	var script_data: ScriptData = _search_attached_script(scn)
	if script_data:
		scene_data.get_properties().set_attached_script(script_data)

	scene_data.get_properties().set_editor_description(scn.editor_description)

	return scene_data

## Search the attached script a [param scn] would have[br]
## If the scene have a script, returns an instance of
## [class ScriptData]
func _search_attached_script(scn: Node) -> ScriptData:
	var script: Script = scn.get_script()
	if not script:
		return null

	var script_data_path: String = script.resource_path
	var script_data: ScriptData = _script_parser_manager.find_script_with_path(script_data_path)
	
	script_data.is_tool = script.is_tool()

	return script_data

# TODO: Scenes can have childs with an attached script without being instances,
# find a way to check each child of a scene and add its script to the original scene
# if it doesnt is a previously created instance

func _filter_children(instance_children: Array[Node], 
					own_children: Array[Node]) -> Array[Node]:
	var instance_children_names: Array[String] = []
	for child: Node in instance_children:
		instance_children_names.append(child.name)

	return own_children.filter(func(x: Node) -> bool: return x.name in instance_children_names)

## Handles an instance found inside a node[br]
## [param instance_path] is the path of the instance[br]
## [param current_scene] is the scene whos istance belongs to[br]
## [param child] is the instance node found in [param current_scene][br]
## searchs for the children [param child] has, excluding its own children
## and only counting the ones declared within [param current_scene] scene
func _handle_instance(instance_path: String, 
					current_scene: SceneData,
					child: Node) -> void:
	current_scene.get_properties().add_instance(instance_path)

	var current_instance: Node = _open_scene(instance_path)
	var child_nodes: Array[Node] = child.get_children()
	var scene_nodes: Array[Node] = current_instance.get_children()
	var new_children: Array[Node] = _filter_children(child_nodes, scene_nodes)
	current_instance.free()
	_search_instances(current_scene, new_children)

## Uses a [param scn] scene and access to its children and
## calls recursively with each children of the node[br]
## For each instance, adds it to the current [param scene_data]
func _search_instances(scene_data: SceneData, children: Array[Node]) -> void:
	if children.is_empty():
		return

	for child: Node in children:
		var child_path: String = child.scene_file_path
		if child_path != "":
			_handle_instance(child_path, scene_data, child)
			continue

		_search_instances(scene_data, child.get_children())

## Parses all scenes files in the project[br]
## Uses [param script_files] to initialize the script parser[br]
## Uses [param scene_files] to open each path as a scene
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
