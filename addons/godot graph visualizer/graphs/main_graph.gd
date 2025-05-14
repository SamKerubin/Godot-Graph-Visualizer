@tool
extends GraphEdit

const SCENE_NODE: PackedScene = preload("uid://dqo7imj3ce8ji")

var scenes: Array[SceneData]

func _ready() -> void:
	scenes = ScenePropertyManager.get_scenes_properties()
	_create_nodes()

func _create_nodes() -> void:
	for scn: SceneData in scenes:
		var scene_node: GraphElement = SCENE_NODE.instantiate()
		add_child(scene_node)
		print(size)
		scene_node.position = Vector2(100, 200)
		print("size ", scene_node.size)
		print(scene_node.position)

		scene_node.initialize(scn)
