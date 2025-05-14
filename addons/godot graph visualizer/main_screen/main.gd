@tool
extends Control
## @experimental: This class is currently being used to perform tests

func _on_scene_manager_initialized() -> void:
	create_scene_nodes()

func _on_scripts_parsed() -> void: 
	create_script_nodes()

func create_script_nodes() -> void:
	pass

func create_scene_nodes() -> void: 
	pass

func save() -> void: pass
