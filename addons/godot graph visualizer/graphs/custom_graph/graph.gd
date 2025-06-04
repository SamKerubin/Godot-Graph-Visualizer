@tool
extends GraphEdit

signal node_loaded(node: SamGraphNode)

const LOADING_SCREEN: PackedScene = preload("uid://bncf27fvmqnxe")

const GRAPH_NODE_SCENE: PackedScene = preload("uid://bo153wubc0sl1")

var loading_screen_instance: Panel = null

func create_loading_screen() -> void:
	if not loading_screen_instance:
		loading_screen_instance = LOADING_SCREEN.instantiate()
		add_child(loading_screen_instance)
		loading_screen_instance.set_size.call_deferred(size)
		loading_screen_instance.z_index = 100

func _delete_loading_screen() -> void:
	if loading_screen_instance:
		remove_child(loading_screen_instance)
		loading_screen_instance.queue_free()

func set_nodes(nodes: Array[SceneData], 
				node_connections: Array[RelationData], 
				node_color: Color, connection_color: Color) -> void:

	clear_graph.call_deferred()

	for node: SceneData in nodes:
		var new_node: SamGraphNode = GRAPH_NODE_SCENE.instantiate()

		add_child(new_node)

		var node_name: String = node.get_node_name().capitalize()

		new_node.name = node_name
		new_node.title = node_name
		new_node.node_path = node.get_node_path()
		new_node.modulate = node_color

		node_loaded.emit(new_node)

	_set_connections(node_connections, connection_color)

	_delete_loading_screen()

func _set_connections(node_connections: Array[RelationData], connection_color: Color) -> void:
	# Use graph connections variable,
	# Update for each element inside the array
	# Keep in mind, research about how a GraphEdit saves the connections
	# Cuz i still dont know how that works
	pass

# Ill implement an algorithm to auto-sort nodes in the graph (later obv)
func _set_next_position() -> Vector2: return Vector2.ZERO 
# For sorting algorithm, ill maybe implement something cluster-based
# Its easier sorting nodes by groups than all apart
# I can group them like a tree, father and childs
# Each father got its own container (cluster)
# The cluster can move to be near other nodes

func clear_graph() -> void:
	for node: Control in get_children():
		if not node is SamGraphNode: continue

		remove_child(node)
		node.queue_free()

	clear_connections()
