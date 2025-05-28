@tool
extends GraphEdit

signal content_loaded

const GRAPH_NODE_SCENE: PackedScene = preload(
	"res://addons/godot graph visualizer/graphs/custom_graph/custom_graph_nodes/SamGraphNode.tscn"
	)

func set_nodes(nodes: Array[SceneData], 
				node_connections: Array[Dictionary], 
				node_color: Color, connection_color: Color) -> void:

	for node: SceneData in nodes:
		var new_node: GraphNode = GRAPH_NODE_SCENE.instantiate()
		add_child(new_node)

		new_node.initialize(node)
		new_node.set_position_offset(_set_next_position())

		var node_name: String = node.get_node_name().capitalize()
		new_node.name = node_name
		new_node.title = node_name
		new_node.modulate = node_color

	_set_connections(node_connections, connection_color)
	
	content_loaded.emit()

func _set_connections(node_connections: Array[Dictionary], connection_color: Color) -> void:
	# Use graph connections variable,
	# Update for each element inside the array
	# Keep in mind, research about how a GraphEdit saves the connections
	# Cuz i still dont know how that works
	pass

# Ill implement an algorithm to auto-sort nodes in the graph (later obv)
func _set_next_position() -> Vector2: return Vector2.ZERO 

func clear_graph() -> void:
	for node: Control in get_children():
		remove_child(node)
		node.queue_free()

	connections = []
