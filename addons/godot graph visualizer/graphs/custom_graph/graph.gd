@tool
extends GraphEdit

const LOADING_SCREEN: PackedScene = preload("uid://bncf27fvmqnxe")

var _loading_screen_instance: Panel = null

func create_loading_screen() -> void:
	if not _loading_screen_instance:
		_loading_screen_instance = LOADING_SCREEN.instantiate()
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
