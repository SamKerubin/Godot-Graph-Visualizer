@tool
extends Resource
class_name NodeFilter

var _temp_scene_properties: ScenePropertyManager

func _init(scene_properties: ScenePropertyManager) -> void:
	_temp_scene_properties = scene_properties

func filter_nodes_by_type(type: String, nodes: Array[SceneData]) -> Array[Dictionary]:
	var comparator: Callable
	if type == "instance": comparator = _node_has_instance
	elif type == "packedscene": comparator = _node_has_packedscene
	
	if nodes.is_empty(): return []

	var references: Array[Dictionary] = []
	for n: SceneData in nodes:
		# Comparator checks if its a valid node for be added to the references array
		if comparator.call(n):
			# This is just a test case,
			# i need to do a nested loop to
			# iterate over all the references of a single node
			# Append a dictionary with:
			# The current node name
			# The current node reference name
			# (if its a path, uses _temp_scene_properties to get the name)
			# Times referenced the current reference
			references.append({
				"from": "",
				"to": "",
				"references": 0
			})
	
	return references

func _node_has_instance(node: SceneData) -> bool:
	# Check if scene have internal instances
	# Check if scene have a script and also, if this script have instances
	return true

func _node_has_packedscene(node: SceneData) -> bool:
	# Check if a scene have a script and also, if this script have packedscenes
	# referenced
	return true
