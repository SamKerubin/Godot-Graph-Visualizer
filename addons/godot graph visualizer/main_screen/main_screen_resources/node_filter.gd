@tool
extends Resource
class_name NodeFilter

var _temp_scene_properties: ScenePropertyManager

func set_temporal_properties(scene_properties: ScenePropertyManager) -> void:
	_temp_scene_properties = scene_properties

func filter_nodes_by_type(type: String, nodes: Array[SceneData]) -> Array[RelationData]:
	var relation_manager: RelationManager = RelationManager.new()

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

	for n: SceneData in nodes:
		var current_name: String = n.get_node_name().capitalize()
		var current_path: String = n.get_node_path()

		var new_relation: RelationData = relation_manager.find_relation_with_name(current_name)
		if not new_relation: new_relation = RelationData.new(current_name, current_path)

		var serialized_node: Dictionary = n.serialize()
		var current_relations: Dictionary = comparator.call(n, serialized_node) as Dictionary

		for ref: String in current_relations:
			var relation_scene: SceneData = _temp_scene_properties.find_scene_with_path(ref)

			var relation_path: String = relation_scene.get_node_path()
			var scene_name: String = relation_scene.get_node_name().capitalize()
			
			var existing_relation: RelationData = relation_manager.find_relation_with_name(scene_name)
			if not existing_relation: existing_relation = RelationData.new(scene_name, relation_path)

			new_relation.add_outgoing_node(existing_relation, current_relations[ref])
			existing_relation.add_incoming_node(new_relation, current_relations[ref])

		relation_manager.relations.append(new_relation)

	return relation_manager.relations

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
