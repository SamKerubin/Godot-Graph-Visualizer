@tool
extends Resource
class_name ConnectionInfo

var references: Array[ConnectionReference]

var start: String

func get_connections_with_end(ending_path: String) -> Array[ConnectionReference]:
	return references.filter(func(x: ConnectionReference) -> bool: return x.end == ending_path)

func get_connections_from_type(type: ConnectionIndex.ConnectionType) -> Array[ConnectionReference]:
	return references.filter(func(x: ConnectionReference) -> bool: return x.type == type)
