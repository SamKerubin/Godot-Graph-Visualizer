@tool
extends EditorPlugin

const MAIN_PANEL: PackedScene = preload("uid://c4h2pps361nfk")
const ICON: Texture2D = preload("res://icon.svg")
const PLUGIN_NAME: String = "Visualize Project"

var main_panel_instance : Main

func _enter_tree() -> void:
	add_custom_type(PLUGIN_NAME, "Node", preload("uid://d1sog8u4bym8g"), ICON)

	main_panel_instance = MAIN_PANEL.instantiate()
	print("instance: ", main_panel_instance)

	get_editor_interface().get_editor_main_screen().add_child(main_panel_instance)
	main_panel_instance.visible = false

	_make_visible(false)

func _exit_tree() -> void:
	remove_custom_type(PLUGIN_NAME)
	if main_panel_instance:
		main_panel_instance.queue_free()

func _has_main_screen() -> bool:
	return true

func _make_visible(visible: bool) -> void:
	if main_panel_instance:
		main_panel_instance.visible = visible

func _get_plugin_name() -> String:
	return PLUGIN_NAME

func _get_plugin_icon() -> Texture2D:
	return ICON

func _save_external_data() -> void:
	main_panel_instance.save()
