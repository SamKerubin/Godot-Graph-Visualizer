@tool
extends GraphEdit

## @experimental: This class is currently under development, except changes and some testing

const _LOADING_SCREEN: PackedScene = preload("uid://bncf27fvmqnxe")

var _loading_screen_instance: Panel

func _on_layout_loaded(mapped_nodes: Dictionary[RelationData, SamGraphNode]) -> void:
	_connect_nodes(mapped_nodes)

# FIXME
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
			#print(">>> CONNECTING:")
			#prints("FROM:", from_node.name, "OUT slot:", from_slot, "/", from_node.get_output_port_count())
			#prints("TO  :", to_node.name, "IN slot:", to_slot, "/", to_node.get_input_port_count())

			connect_node(from_node.name, from_slot, to_node.name, to_slot)

func _set_all_slots(mapped_nodes: Dictionary[RelationData, SamGraphNode]) \
				-> Dictionary[SamGraphNode, Dictionary]:

	var slot_map: Dictionary[SamGraphNode, Dictionary] = {}

	for relation: RelationData in mapped_nodes.keys():
		var node: SamGraphNode = mapped_nodes[relation]

		slot_map[node] = {} as Dictionary[RelationData, int]

		var relations: Array[RelationData] = []
		relations += relation.incoming.keys()
		relations += relation.outgoing.keys()

		if relations.is_empty(): continue

		var index: int = 0
		for rel: RelationData in relations:
			var is_incoming: bool = relation.incoming.has(rel)
			var is_outgoing: bool = relation.outgoing.has(rel)

			node.set_custom_slot(index, is_incoming, is_outgoing, TYPE_INT, Color.WHITE)
			#prints("Slot creado en:", node.name, "index:", index)
			#prints("  Input?", is_incoming, "Output?", is_outgoing)
			#prints("  Actual OUT count:", node.get_output_port_count(), "IN count:", node.get_input_port_count())

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
