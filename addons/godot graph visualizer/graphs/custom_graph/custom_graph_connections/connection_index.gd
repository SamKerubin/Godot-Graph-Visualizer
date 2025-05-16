@tool
extends Resource
class_name ConnectionIndex

const CONNECTIONS: Dictionary[ConnectionType, PackedScene] = {
	ConnectionType.PRELOAD_TYPE: preload("uid://l5cpt0qkhb5t"),
	ConnectionType.LOAD_TYPE: preload("uid://rf8xh5m5ms4c"),
	ConnectionType.INSTANCE_TYPE: preload("uid://b2hab46v3vutm")
}

enum ConnectionType {
	PRELOAD_TYPE,
	LOAD_TYPE,
	INSTANCE_TYPE,
	# For later, but ill explain now to not be lost when i come back
	# When you have more than one type of reference between two or more scenes,
	# It will display a different type of connection, refering to a crossed connection
	PRELOAD_INSTANCE_TYPE,
	LOAD_INSTANCE_TYPE
	# PRELOAD_LOAD_INSTANCE <-- Im not sure about this one yet
}
