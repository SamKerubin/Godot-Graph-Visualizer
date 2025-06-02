@tool
extends Resource
class_name NodeFilter

var _temp_scene_properties: ScenePropertyManager

func set_temporal_properties(scene_properties: ScenePropertyManager) -> void:
	_temp_scene_properties = scene_properties

func filter_nodes_by_type(type: String, nodes: Array[SceneData]) -> Array[ConnectionData]:
	if not _temp_scene_properties:
		push_error("Error: Scene Properties have a null or invalid value")
		return []

	if nodes.is_empty(): return []

	var comparator: Callable
	if type == "instance": comparator = _get_node_instances
	elif type == "packedscene": comparator = _get_node_packedscenes

	if not comparator:
		push_error("Error: Couldnt filter nodes with a reference of type \'%s\'" % type)
		return []

	var references: Array[ConnectionData] = []
	for n: SceneData in nodes:
		var serialized_node: Dictionary = n.serialize()
		var current_references: Dictionary = comparator.call(n, serialized_node)

		if current_references.is_empty(): continue

		var current_node: String = n.get_node_name().capitalize()

		for ref: String in current_references:
			var current_reference_data: SceneData = _temp_scene_properties.find_scene_with_path(ref)
			var current_reference_name: String = current_reference_data.get_node_name().capitalize()
			var times_references: int = current_references[ref]

			var script_data: ScriptData = n.get_properties().get_attached_script()
			var script_path: String = script_data.get_node_path() \
			if script_data \
			else "No attached script"

			var new_connection_data: ConnectionData = ConnectionData.new()
			new_connection_data.from = current_node
			new_connection_data.to = current_reference_name
			new_connection_data.times_referenced = times_references
			new_connection_data.attached_script = script_path

			references.append(new_connection_data)

	return references

func _get_node_instances(node: SceneData, serialized_node: Dictionary) -> Dictionary:
	var internal_instances: Dictionary = serialized_node.get("instance", {})
	var attached_script: Dictionary = serialized_node.get("attached_script", {})
	if internal_instances.is_empty() and attached_script.is_empty(): return {}

	var script_instances: Dictionary = attached_script.get("instance", {})
	for scr_inst: String in script_instances:
		internal_instances[scr_inst] = internal_instances.get(scr_inst, 0) + script_instances[scr_inst]

	return internal_instances

func _get_node_packedscenes(node: SceneData, serialized_node: Dictionary) -> Dictionary:
	var attached_script: Dictionary = serialized_node.get("attached_script", {})
	if attached_script.is_empty(): return {}

	return attached_script.get("packedscene", {})
