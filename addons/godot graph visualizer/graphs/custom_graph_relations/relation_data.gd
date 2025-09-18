@tool
extends Resource
class_name RelationData

var node_name: String
var node_path: String
var incoming: Dictionary[RelationData, int]
var outgoing: Dictionary[RelationData, int]

func _init(name: String, path: String) -> void:
	node_name = name
	node_path = path

func add_incoming_node(node: RelationData, times_referenced: int) -> void:
	incoming[node] = incoming.get(node, 0) + times_referenced

func add_outgoing_node(node: RelationData, times_references: int) -> void:
	outgoing[node] = outgoing.get(node, 0) + times_references

func have_any_relation() -> bool:
	return not incoming.is_empty() or not outgoing.is_empty()
