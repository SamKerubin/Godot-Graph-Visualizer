@tool
extends EditorPlugin

const MAIN_PANEL: PackedScene = preload("uid://c4h2pps361nfk")
const ICON: Texture2D = preload("res://addons/icon.png")
const PLUGIN_NAME: String = "Visualize Project"

var main_panel_instance: Control

func _enter_tree() -> void:
	add_autoload_singleton("FileScanner", "res://addons/godot graph visualizer/project_scanners/file_scanner.gd")
	add_autoload_singleton("ScenePropertyManager", "res://addons/godot graph visualizer/project_scanners/scene_scanner/scene_property_manager.gd")
	add_autoload_singleton("ScriptParserManager", "res://addons/godot graph visualizer/project_scanners/script_scanner/script_parser_manager.gd")

	await get_tree().process_frame

	main_panel_instance = MAIN_PANEL.instantiate()
	print("instance: ", main_panel_instance)
	get_editor_interface().get_editor_main_screen().add_child(main_panel_instance)
	
	ScriptParserManager.initialize.connect(main_panel_instance._on_scripts_parsed)
	ScriptParserManager.parse_all_scripts()

	ScenePropertyManager.initialize.connect(main_panel_instance._on_scene_manager_initialized)
	ScenePropertyManager.search_properties_in_all_scenes.call_deferred()

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
