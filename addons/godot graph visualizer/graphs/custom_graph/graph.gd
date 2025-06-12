@tool
extends GraphEdit

## @experimental: This class is currently under development, except changes and some testing

const _LOADING_SCREEN: PackedScene = preload("uid://bncf27fvmqnxe")

var _loading_screen_instance: Panel

func _on_layout_loaded(mapped_nodes: Dictionary[RelationData, SamGraphNode]) -> void:
	_connect_nodes(mapped_nodes)

# TODO: Add a label for each node placed that displays the times a relation is made
func _connect_nodes(mapped_nodes: Dictionary[RelationData, SamGraphNode]) -> void:
	var slot_map: Dictionary[SamGraphNode, Dictionary] = _set_all_slots(mapped_nodes)

	for from_rel: RelationData in mapped_nodes:
		var from_node: SamGraphNode = mapped_nodes[from_rel]

		for to_rel: RelationData in from_rel.outgoing.keys():
			if not mapped_nodes.has(to_rel): continue

			var to_node: SamGraphNode = mapped_nodes[to_rel]

			var from_slot: int = slot_map[from_node][to_rel]
			var to_slot: int = slot_map[to_node][from_rel]
			print(from_node.title)
			print(from_node.is_slot_enabled_right(from_slot))
			print(from_slot)

			print(to_node.title)
			print(to_node.is_slot_enabled_left(to_slot))
			print(to_slot)

			print("From node: ", from_node.name, " From slot: ", from_slot)
			print("To node: ", to_node.name, " To slot: ", to_slot)

			connect_node(from_node.name, from_slot, to_node.name, to_slot)

func _set_all_slots(mapped_nodes: Dictionary[RelationData, SamGraphNode]) \
				-> Dictionary[SamGraphNode, Dictionary]:

	var slot_map: Dictionary[SamGraphNode, Dictionary] = {}

	for relation: RelationData in mapped_nodes.keys():
		var node: SamGraphNode = mapped_nodes[relation]
		slot_map[node] = {}

		var index: int = 0
		var relations: Array[RelationData] = []
		relations += relation.incoming.keys()
		relations += relation.outgoing.keys()

		for rel in relations:
			var is_incoming: bool = relation.incoming.has(rel)
			var is_outgoing: bool = relation.outgoing.has(rel)

			node.set_slot(index, is_incoming, TYPE_INT, Color.WHITE, is_outgoing, TYPE_INT, Color.WHITE)

			slot_map[node][rel] = index
			index += 1

	return slot_map

func create_loading_screen() -> void:
	if not _loading_screen_instance:
		_loading_screen_instance = _LOADING_SCREEN.instantiate()
		add_child(_loading_screen_instance)
		_loading_screen_instance.set_size.call_deferred(size)
		_loading_screen_instance.z_index = 100

func delete_loading_screen() -> void:
	if _loading_screen_instance:
		remove_child(_loading_screen_instance)
		_loading_screen_instance.queue_free()

func clear_graph() -> void:
	for node: Control in get_children():
		if not node is SamGraphNode: continue

		remove_child(node)
		node.queue_free()

	clear_connections()
