@tool
extends Node

signal managers_initialized

var script_property_manager: ScriptPropetyManager = ScriptPropetyManager.new()

func initialize_all_managers() -> void:
	script_property_manager.search_properties_in_all_scripts()
	managers_initialized.emit()
