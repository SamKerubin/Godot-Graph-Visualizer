@tool
extends EditorPlugin

const MAIN_PANEL: PackedScene = preload("uid://c4h2pps361nfk")
const ICON: Texture2D = preload("res://addons/icon.png")
const PLUGIN_NAME: String = "Visualize Project"

var main_panel_instance: Control

func _enter_tree() -> void:
	push_warning(
		"Warning: This plugin its still on beta and may be up to changes\n" \
		+ "If you encounter any bug or have any suggestion, dont be afraid to tell me :3\n\t" \
		+ "GitHub: @SamKerubin\n\tEmail: samuelkiller2013@gmail.com"
	)
	main_panel_instance = MAIN_PANEL.instantiate()
	if not main_panel_instance:
		push_error(
			"Error: Couldnt load plugin, if the error persists, please contact me:\n\t" \
			+ "GitHub: @SamKerubin\n\tEmail: samuelkiller2013@gmail.com"
		)

		return

	get_editor_interface().get_editor_main_screen().add_child(main_panel_instance)

	main_panel_instance.visible = false

	_make_visible(false)

func _exit_tree() -> void:
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
