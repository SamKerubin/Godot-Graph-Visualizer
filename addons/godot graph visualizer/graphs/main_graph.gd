@tool
extends GraphEdit

const SCENE_NODE: PackedScene = preload("uid://dqo7imj3ce8ji")

var scenes: Array[SceneData]

func _ready() -> void:
	scenes = ScenePropertyManager.get_scenes_properties()
	_create_nodes()

func _create_nodes() -> void:
	for scn: SceneData in scenes:
		var scene_node: GraphNode = SCENE_NODE.instantiate()
		add_child(scene_node)

		scene_node.position = Vector2(100, 200)

		scene_node.initialize(scn)

func _find_child_with_path(path: String) -> GraphNode:
	for child: GraphNode in get_children():
		if child.path == path: return child

	return null
