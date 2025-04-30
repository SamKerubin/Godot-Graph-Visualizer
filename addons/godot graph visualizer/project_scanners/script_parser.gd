@tool
extends Node
class_name ScriptParser

const PRELOAD_RERERENCE: String = "preload\\(\\s*(\"(?:uid://[^\"]+|res://[^\"]+)\")\\s*\\)"
const LOAD_REFERENCE: String = "load\\(\\s*(\"(?:uid://[^\"]+|res://[^\"]+)\")\\s*\\)"
const INSTANTIATE_REFERENCE: String = "(?:load|preload)\\(\\s*(\"(?:uid://[^\"]+|res://[^\"]+)\")\\s*\\)\\.instantiate\\(\\)"
const NEW_RESOURCE_REFERENCE: String = "\\b([A-Z]\\w*)\\.new\\(\\)"

func parse_script(path: String) -> void: pass
