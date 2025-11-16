@tool
extends Control

@onready var documentation: RichTextLabel = $MarginContainer/VBoxContainer/Documentation

var formatted: String = ""

var _documentation_formatter: DocumentationFormatter

func _ready() -> void:
	_documentation_formatter = DocumentationFormatter.new()

func set_documentation(doc: String) -> void:
	if formatted.is_empty():
		formatted = _documentation_formatter.format_text(doc)

	documentation.text = formatted

func clear_documentation() -> void:
	documentation.text = ""
