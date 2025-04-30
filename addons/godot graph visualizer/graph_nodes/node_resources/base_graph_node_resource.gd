@tool
extends Resource
##@experimental: This class is currently under development, stay tunned with the constants updates to see
## future changes 
class_name BaseGraphNodeResource

@export var _node_name: String
@export var _node_path: String
@export var _uid: String = "uid://<invalid>"
@export var _uid_int: int = ResourceUID.INVALID_ID

func _set_node_uid(path: String) -> bool:
	var uid_int: int = ResourceLoader.get_resource_uid(path)
	if uid_int == ResourceUID.INVALID_ID: return false

	_uid_int = uid_int
	_uid = ResourceUID.id_to_text(uid_int)

	return true

func initialize(node_path: String) -> void:
	if not ResourceLoader.exists(node_path):
		push_error("Error: Path \'%s\' not found or does not exists" % node_path)
		return

	if not _set_node_uid(node_path):
		push_error("Error: Unnable to create resource from file \'%s\'" % node_path)
		return

	_node_path = node_path
	_node_name = node_path.get_file().get_basename()

func get_node_name() -> String:
	return _node_name

func get_node_path() -> String:
	return _node_path

func get_uid_text() -> String:
	return _uid

func get_uid_int() -> int:
	return _uid_int
