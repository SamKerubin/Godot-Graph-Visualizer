@tool
extends EditorPlugin

const MAIN_PANEL: PackedScene = preload("uid://c4h2pps361nfk")
const ICON: Texture2D = preload("res://addons/icon.png")
const PLUGIN_NAME: String = "Visualize Project"

var main_panel_instance: Control

func _enter_tree() -> void:
	var version: String
	var plugin_name: String

	var cfg: ConfigFile = ConfigFile.new()
	if cfg.load("res://addons/godot graph visualizer/plugin.cfg") == OK:
		version = cfg.get_value("plugin", "version", "1.0.0")
		plugin_name = cfg.get_value("plugin", "name", "GodotGraphVisualizer")

	push_warning("
[INFO]
\n
Hello! This is Sam, youre currently using the %s version of this plugin,
called %s.
\n
Please, keep in mind:
\n
\t- This plugin is still under development
\t- Many things arent completely done and are up to many changes
\n
I would be so thankful if you give a feedback of this project.
\n
If a custom error message appears, most of the time you want to ignore it.
As im still developing this, i use lots of error messages to debug and test things
(yes, i dont know how to use the debugger in tool mode).
\n
Thank you so much for giving a try to my first project ever <3
\n
If youre interesed on contacting me, here you got some of my accounts:
\n
Github: SamKerubin
Instagram: @SamKerubin
Email: sammm.1618033@gmail.com
\n
Ily :3
\n
Hope you enjoy using this beautiful plugin <3
	" % [version, plugin_name])

	main_panel_instance = MAIN_PANEL.instantiate()
	if not main_panel_instance:
		push_error(
			"Error: Couldnt load plugin, if the error persists, please contact me:\n\t" \
			+ "GitHub: @SamKerubin\n\tEmail: samuelkiller2013@gmail.com"
		)

		return

	get_editor_interface().get_editor_main_screen().add_child(main_panel_instance)
	main_panel_instance.load_instance()

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
