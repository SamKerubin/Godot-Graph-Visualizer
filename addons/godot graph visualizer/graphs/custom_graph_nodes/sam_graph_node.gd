@tool
extends GraphNode
class_name SamGraphNode

signal node_clicked(node_name: String)
signal node_hovered(node_name: String)
signal node_unhovered

@onready var node_name := $PlaceHolder/NodeName

var node_path: String = "res://"

# FIXME
func set_custom_slot(index: int, is_incoming: bool, is_outgoing: bool, type: int, color: Color) -> void:
	if get_child_count() <= index:
		var placeholder = Control.new()
		placeholder.name = "Slot %d" % index
		add_child(placeholder)

	""" This shouldnt be working like this, but ill fix it later """
	set_slot(index, true, type, color, true, type, color)

func set_node_name(n_name: String) -> void:
	if not node_name: node_name = $PlaceHolder/NodeName
	node_name.text = n_name

func _gui_input(event: InputEvent) -> void:
	# Manage this events:
	# - Hover -> Barely show information of the node
	# - Click -> Display bottom menu with the information of the node
	# - Double Click -> Open the nodes scene
	if event is InputEventMouseButton:
		if event.is_double_click():
			EditorInterface.open_scene_from_path(node_path)

		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			node_clicked.emit(name)

func _on_mouse_entered() -> void:
	node_hovered.emit(name)

func _on_mouse_exited() -> void:
	node_unhovered.emit()
