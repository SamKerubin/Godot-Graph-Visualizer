@tool
extends Node

signal scopes_initialized

var script_scope_manager: ScriptScopeManager = ScriptScopeManager.new()

func initialize_all_scopes() -> void:
	script_scope_manager.search_scopes_in_all_scripts()
	scopes_initialized.emit()
