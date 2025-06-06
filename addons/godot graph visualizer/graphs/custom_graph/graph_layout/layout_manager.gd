@tool
extends Resource
class_name LayoutManager

## Class made to manage the main graph layout
## see [class SamGraphNode], [class RelationData], [class RelationManager][br]
## @experimental: this class is still under development, expect changes and testing

signal node_loaded(node: SamGraphNode)

const GRAPH_NODE_SCENE: PackedScene = preload("uid://bo153wubc0sl1")

var mapped_nodes: Dictionary[RelationData, SamGraphNode] = {}

func set_up_layout(node_relations: Array[RelationData], graph: GraphEdit) -> void:
	_map_nodes(node_relations, graph)
	var roots: Array[RelationData] = _get_roots(node_relations)

	_place_roots(roots)

func _map_nodes(node_relations: Array[RelationData], graph: GraphEdit) -> void:
	for relation: RelationData in node_relations:
		var new_graph_node: SamGraphNode = GRAPH_NODE_SCENE.instantiate()

		new_graph_node.title = relation.node_name
		new_graph_node.name = relation.node_name
		new_graph_node.node_path = relation.node_path

		graph.add_child(new_graph_node)
		mapped_nodes[relation] = new_graph_node

func _get_roots(node_relations: Array[RelationData]) -> Array[RelationData]:
	return node_relations.filter(func(x: RelationData) -> bool:
		return x.incoming.is_empty() and not x.outgoing.is_empty()
	)

func _place_roots(roots: Array[RelationData]) -> void:

	var x_spacing: float = 600.0
	var start_x: float = 100.0
	var start_y: float = 100.0

	for i: int in range(roots.size()):
		var root: RelationData = roots[i]
		var node: SamGraphNode = mapped_nodes[root]
		node.set_position_offset(Vector2(start_x + i * x_spacing, start_y))

		_set_layout_mode(root, node, 1, {})

func _set_layout_mode(relation: RelationData, node: SamGraphNode, 
						depth: int, visited: Dictionary[SamGraphNode, bool]) -> void:

	if visited.has(node): return

	visited[node] = true

	var children: Dictionary[RelationData, int] = relation.outgoing
	var n: int = children.size()

	var position_getter: Callable
	match n:
		1, 2, 3, 4: position_getter = _get_radial_position
		5, 6, 7, 8: position_getter = _get_fan_position
		_: position_getter = _get_grid_position

	var m: int = 1
	for child: RelationData in children:

		# this is still buggy, fix later
		var current_node: SamGraphNode = mapped_nodes.get(child)

		if not current_node: continue

		if visited.has(current_node):
			current_node.position = (current_node.position + node.position) / 2.0
			continue

		var child_position: Vector2 = position_getter.call(node, m, n, depth)
		current_node.set_position_offset(child_position)

		m += 1

		_set_layout_mode(child, current_node, depth + 1, visited)

func _get_radial_position(node: SamGraphNode, m: int, n: int, depth: int) -> Vector2:
	const RADIUS: int = 400
	var angle: float = (-PI / n) * m

	var x: float = node.position.x + cos(angle) * RADIUS
	var y: float = node.position.y + sin(angle) * RADIUS

	return Vector2(x, y)

func _get_fan_position(node: SamGraphNode, m: int, n: int, depth: int) -> Vector2:
	var x: float = node.position.x + depth * 300
	var y: float = node.position.y + (m - n / 2) * 180 
	
	# x = parent.x + (M - N / 2) * 250
	# y = parent.y + depth * 300

	return Vector2(x, y)

func _get_grid_position(node: SamGraphNode, m: int, n: int, depth: int) -> Vector2:
	return Vector2.ZERO

func _get_shared_nodes(node_relations: Array[RelationData]) -> Array[RelationData]:
	return node_relations.filter(func(x: RelationData) -> bool:
		return x.incoming.size() > 1
	)

func _get_unrelated_nodes(node_relations: Array[RelationData]) -> Array[RelationData]:
	return node_relations.filter(func(x: RelationData) -> bool:
		return x.incoming.is_empty() and x.outgoing.is_empty()
	)

# NOTE: im still designing this algorithm, so, the math formulas might be badly done for now

# Search roots (nodes without an incoming relation)
# Place those roots horizontally

# roots []
# for each node ->
# if node.incoming is empty, add to roots []

# for each root ->
# x-spacing = 200
# place node, node.position + x-spacing
# x-spacing += 200

# Search with recursion the relations of each root
# The relations will display in the graph depending on how many relations a node have

# R = relations of a node
# M = number of relation

# if R = (1-4) -> display a radial layout

# formula:
# radius = R / 2 * PI
# angle = (PI / (R + 1) * (M + 1))
# new X = parent node X + cos(angle) * radius
# new Y = parent node Y + sin(angle) * radius

# if R = (5-8) -> display a fan layout

# formula:
# depth = node depth (increments for each node descended)

# OPTION 1:
# new X = parent node X + depth * 300 <- 300 being a constant value to separete them
# new Y = parent node Y + (M - R / 2) * 180

# OPTION 2:
# new X = parent node X + (M - R / 2) * 250
# new Y = parent node Y + depth * 300

# if R = (+8) -> display a grid layout

# formula:
# cols = ceil(sqrt(R))
# rows = floor(M / cols)
# num col = M % cols
# new X = parent node X + col * 300
# new Y = parent node Y + row * 250 + depth * 100

# for each root ->
# search relations of (root)

# in search relation of:
# N = node.relations (size)
# for each relation in node ->
# place node with layout (N)
# search relation of (relation)

# After placing each node, search every shared node
# A shared node is the one that have more than one incoming node

# for each node ->
# if node.incoming.size > 1, replace it and its parents
# average position: (each parent position / incoming.size) + some value in Y

# For each shared node ->
# Replace its parents in an average position
# Replace the shared node in an average position between its parents

# formuala:
# dont have a formula for this yet

# Now, search for unrelated nodes, nodes that doesnt have any relations
# For each node remaining (or also, each node without relations) ->
# Place them in a grid layout away of the main graph

# NOTE: this part of the algorithm is still uncomplete

# for each shared ->
# replace node (shared)

# in replace node:
# position
# for each parent -> position += parent position
# average position = position / shared.incoming.size

# formula: use the grid formula, but using greater values to get away the graph
