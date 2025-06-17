@tool
extends GraphNode
class_name SamGraphNode

signal node_clicked(path: String, node_name: String)
signal node_hovered(path: String, node_name: String)
signal node_unhovered

var node_path: String = "res://"

# FIXME
func set_custom_slot(index: int, is_incoming: bool, is_outgoing: bool, type: int, color: Color) -> void:
	if get_child_count() <= index:
		var placeholder = Control.new()
		placeholder.name = "Slot %d" % index
		add_child(placeholder)

	""" This shouldnt be working like this, but ill fix it later """
	set_slot(index, true, type, color, true, type, color)

func _gui_input(event: InputEvent) -> void:
	# Manage this events:
	# - Hover -> Barely show information of the node
	# - Click -> Display bottom menu with the information of the node
	# - Double Click -> Open the nodes scene
	if event is InputEventMouseButton:
		if event.is_double_click():
			EditorInterface.open_scene_from_path(node_path)

		if event.button_index == MOUSE_BUTTON_LEFT:
			node_clicked.emit(node_path, name)

func _on_mouse_entered() -> void:
	node_hovered.emit(node_path, name)

func _on_mouse_exited() -> void:
	node_unhovered.emit()
